#include "discord_rpc.hpp"
#include "backoff.hpp"
#include "msg_queue.hpp"
#include "rpc_connection.hpp"
#include "serialization.hpp"

#include <atomic>
#include <chrono>
#include <mutex>

#ifndef DISCORD_DISABLE_IO_THREAD
#include <condition_variable>
#include <thread>
#endif

constexpr size_t MaxMessageSize{16 * 1024};
constexpr size_t MessageQueueSize{8};
constexpr size_t JoinQueueSize{8};

struct QueuedMessage
{
	size_t length;
	char buffer[MaxMessageSize];

	void Copy(const QueuedMessage &other)
	{
		length = other.length;

		if (length)
			memcpy(buffer, other.buffer, length);
	}
};

struct User
{
	char userId[32];
	char username[344];
	char globalName[344];
	char discriminator[8];
	char avatar[128];
	DiscordPremiumType premiumType;
	bool bot;
};

static RpcConnection *Connection{nullptr};
static DiscordEventHandlers QueuedHandlers{};
static DiscordEventHandlers Handlers{};
static std::atomic_bool WasJustConnected{false};
static std::atomic_bool WasJustDisconnected{false};
static std::atomic_bool GotErrorMessage{false};
static std::atomic_bool WasJoinGame{false};
static std::atomic_bool WasSpectateGame{false};
static std::atomic_bool UpdatePresence{false};
static char JoinGameSecret[256];
static char SpectateGameSecret[256];
static int LastErrorCode{0};
static char LastErrorMessage[256];
static int LastDisconnectErrorCode{0};
static char LastDisconnectErrorMessage[256];
static std::mutex PresenceMutex;
static std::mutex HandlerMutex;
static QueuedMessage QueuedPresence{};
static MsgQueue<QueuedMessage, MessageQueueSize> SendQueue;
static MsgQueue<User, JoinQueueSize> JoinAskQueue;
static User connectedUser;

// We want to auto connect, and retry on failure, but not as fast as possible.
// This does expoential backoff from 0.5 seconds to 1 minute
static Backoff ReconnectTimeMs(500, 60 * 1000);
static auto NextConnect = std::chrono::system_clock::now();
static int Pid{0};
static int Nonce{1};

#ifndef DISCORD_DISABLE_IO_THREAD
static void Discord_UpdateConnection(void);
class IoThreadHolder
{
private:
	std::atomic_bool keepRunning{true};
	std::mutex waitForIOMutex;
	std::condition_variable waitForIOActivity;
	std::thread ioThread;

public:
	void Start()
	{
		keepRunning.store(true);
		ioThread = std::thread(
		    [&]()
		    {
			    const std::chrono::duration<int64_t, std::milli> maxWait{500LL};
			    Discord_UpdateConnection();
			    while (keepRunning.load())
			    {
				    std::unique_lock<std::mutex> lock(waitForIOMutex);
				    waitForIOActivity.wait_for(lock, maxWait);
				    Discord_UpdateConnection();
			    }
		    });
	}

	void Notify()
	{
		waitForIOActivity.notify_all();
	}

	void Stop()
	{
		keepRunning.exchange(false);

		Notify();

		if (ioThread.joinable())
			ioThread.join();
	}

	~IoThreadHolder()
	{
		Stop();
	}
};
#else
class IoThreadHolder
{
public:
	void Start() {}
	void Stop() {}
	void Notify() {}
};
#endif

static IoThreadHolder *IoThread{nullptr};

#ifdef DISCORD_DISABLE_IO_THREAD
void Discord_UpdateConnection(void)
#else
static void Discord_UpdateConnection(void)
#endif
{
	if (!Connection)
		return;

	if (!Connection->IsOpen())
	{
		if (std::chrono::system_clock::now() >= NextConnect)
		{
			NextConnect =
			    std::chrono::system_clock::now() + std::chrono::duration<int64_t, std::milli>{ReconnectTimeMs.nextDelay()};

			Connection->Open();
		}
	}
	else
	{
		for (;;)
		{
			JsonDocument message;

			if (!Connection->Read(message))
				break;

			const char *evtName = GetStrMember(&message, "evt");
			const char *nonce = GetStrMember(&message, "nonce");

			if (nonce)
			{
				if (evtName && strcmp(evtName, "ERROR") == 0)
				{
					auto data = GetObjMember(&message, "data");
					LastErrorCode = GetIntMember(data, "code");
					StringCopy(LastErrorMessage, GetStrMember(data, "message", ""));
					GotErrorMessage.store(true);
				}
			}
			else
			{
				if (evtName == nullptr)
					continue;

				auto data = GetObjMember(&message, "data");

				if (strcmp(evtName, "ACTIVITY_JOIN") == 0)
				{
					auto secret = GetStrMember(data, "secret");

					if (secret)
					{
						StringCopy(JoinGameSecret, secret);

						WasJoinGame.store(true);
					}
				}
				else if (strcmp(evtName, "ACTIVITY_SPECTATE") == 0)
				{
					auto secret = GetStrMember(data, "secret");

					if (secret)
					{
						StringCopy(SpectateGameSecret, secret);

						WasSpectateGame.store(true);
					}
				}
				else if (strcmp(evtName, "ACTIVITY_JOIN_REQUEST") == 0)
				{
					auto user = GetObjMember(data, "user");
					auto userId = GetStrMember(user, "id");
					auto username = GetStrMember(user, "username");

					auto joinReq = JoinAskQueue.GetNextAddMessage();

					if (userId && username && joinReq)
					{
						StringCopy(joinReq->userId, userId);
						StringCopy(joinReq->username, username);
						StringCopyOptional(joinReq->globalName, GetStrMember(user, "global_name"));
						StringCopyOptional(joinReq->discriminator, GetStrMember(user, "discriminator"));
						StringCopyOptional(joinReq->avatar, GetStrMember(user, "avatar"));

						auto premiumType = GetIntMember(user, "premium_type");

						if (premiumType)
							joinReq->premiumType = (DiscordPremiumType)premiumType;

						auto bot = GetBoolMember(user, "bot");

						if (bot)
							joinReq->bot = bot;

						JoinAskQueue.CommitAdd();
					}
				}
			}
		}

		if (UpdatePresence.exchange(false) && QueuedPresence.length)
		{
			QueuedMessage local;

			{
				std::lock_guard<std::mutex> guard(PresenceMutex);

				local.Copy(QueuedPresence);
			}

			if (!Connection->Write(local.buffer, local.length))
			{
				std::lock_guard<std::mutex> guard(PresenceMutex);

				QueuedPresence.Copy(local);

				UpdatePresence.exchange(true);
			}
		}

		while (SendQueue.HavePendingSends())
		{
			auto qmessage = SendQueue.GetNextSendMessage();

			Connection->Write(qmessage->buffer, qmessage->length);

			SendQueue.CommitSend();
		}
	}
}

static void SignalIOActivity()
{
	if (IoThread != nullptr)
		IoThread->Notify();
}

static bool RegisterForEvent(const char *evtName)
{
	auto qmessage = SendQueue.GetNextAddMessage();

	if (qmessage)
	{
		qmessage->length = JsonWriteSubscribeCommand(qmessage->buffer, sizeof(qmessage->buffer), Nonce++, evtName);
		SendQueue.CommitAdd();
		SignalIOActivity();
		return true;
	}

	return false;
}

static bool DeregisterForEvent(const char *evtName)
{
	auto qmessage = SendQueue.GetNextAddMessage();

	if (qmessage)
	{
		qmessage->length = JsonWriteUnsubscribeCommand(qmessage->buffer, sizeof(qmessage->buffer), Nonce++, evtName);
		SendQueue.CommitAdd();
		SignalIOActivity();
		return true;
	}

	return false;
}

void Discord_Initialize(const char *applicationId, DiscordEventHandlers *handlers, bool autoRegister, const char *optionalSteamId)
{
	IoThread = new (std::nothrow) IoThreadHolder();

	if (IoThread == nullptr)
		return;

	if (autoRegister)
		Discord_RegisterSteamGame(applicationId, optionalSteamId && optionalSteamId[0] ? optionalSteamId : nullptr);

	Pid = GetProcessId();

	{
		std::lock_guard<std::mutex> guard(HandlerMutex);

		if (handlers)
			QueuedHandlers = (*handlers);
		else
			QueuedHandlers = {};

		Handlers = {};
	}

	if (Connection)
		return;

	Connection = RpcConnection::Create(applicationId);

	Connection->onConnect = [](JsonDocument &readyMessage)
	{
		Discord_UpdateHandlers(&QueuedHandlers);

		if (QueuedPresence.length > 0)
		{
			UpdatePresence.exchange(true);
			SignalIOActivity();
		}

		auto data = GetObjMember(&readyMessage, "data");
		auto user = GetObjMember(data, "user");

		auto userId = GetStrMember(user, "id");
		auto username = GetStrMember(user, "username");

		if (userId && username)
		{
			StringCopy(connectedUser.userId, userId);
			StringCopy(connectedUser.username, username);
			StringCopyOptional(connectedUser.globalName, GetStrMember(user, "global_name"));
			StringCopyOptional(connectedUser.discriminator, GetStrMember(user, "discriminator"));
			StringCopyOptional(connectedUser.avatar, GetStrMember(user, "avatar"));

			auto premiumType = GetIntMember(user, "premium_type");

			if (premiumType)
				connectedUser.premiumType = (DiscordPremiumType)premiumType;

			auto bot = GetBoolMember(user, "bot");

			if (bot)
				connectedUser.bot = bot;
		}

		WasJustConnected.exchange(true);
		ReconnectTimeMs.reset();
	};

	Connection->onDisconnect = [](int err, const char *message)
	{
		LastDisconnectErrorCode = err;
		StringCopy(LastDisconnectErrorMessage, message);
		WasJustDisconnected.exchange(true);

		NextConnect = std::chrono::system_clock::now() + std::chrono::duration<int64_t, std::milli>{ReconnectTimeMs.nextDelay()};
	};

	IoThread->Start();
}

void Discord_Shutdown(void)
{
	if (!Connection)
		return;

	Connection->onConnect = nullptr;
	Connection->onDisconnect = nullptr;

	Handlers = {};

	QueuedPresence.length = 0;
	UpdatePresence.exchange(false);

	if (IoThread != nullptr)
	{
		IoThread->Stop();
		delete IoThread;
		IoThread = nullptr;
	}

	RpcConnection::Destroy(Connection);
}

void Discord_UpdatePresence(const DiscordRichPresence *presence)
{
	{
		std::lock_guard<std::mutex> guard(PresenceMutex);
		QueuedPresence.length =
		    JsonWriteRichPresenceObj(QueuedPresence.buffer, sizeof(QueuedPresence.buffer), Nonce++, Pid, presence);
		UpdatePresence.exchange(true);
	}

	SignalIOActivity();
}

void Discord_ClearPresence(void)
{
	Discord_UpdatePresence(nullptr);
}

void Discord_Respond(const char *userId, DiscordActivityJoinRequestReply reply)
{
	if (!Connection || !Connection->IsOpen())
		return;

	auto qmessage = SendQueue.GetNextAddMessage();

	if (qmessage)
	{
		qmessage->length = JsonWriteJoinReply(qmessage->buffer, sizeof(qmessage->buffer), userId, reply, Nonce++);
		SendQueue.CommitAdd();
		SignalIOActivity();
	}
}

void Discord_RunCallbacks(void)
{
	if (!Connection)
		return;

	bool wasDisconnected = WasJustDisconnected.exchange(false);
	bool isConnected = Connection->IsOpen();

	if (isConnected && wasDisconnected)
	{
		std::lock_guard<std::mutex> guard(HandlerMutex);

		if (Handlers.disconnected)
			Handlers.disconnected(LastDisconnectErrorCode, LastDisconnectErrorMessage);
	}

	if (WasJustConnected.exchange(false))
	{
		std::lock_guard<std::mutex> guard(HandlerMutex);

		if (Handlers.ready)
		{
			DiscordUser du{connectedUser.userId,
				       connectedUser.username,
				       connectedUser.globalName,
				       connectedUser.discriminator,
				       connectedUser.avatar,
				       connectedUser.premiumType,
				       connectedUser.bot};

			Handlers.ready(&du);
		}
	}

	if (GotErrorMessage.exchange(false))
	{
		std::lock_guard<std::mutex> guard(HandlerMutex);

		if (Handlers.errored)
			Handlers.errored(LastErrorCode, LastErrorMessage);
	}

	if (WasJoinGame.exchange(false))
	{
		std::lock_guard<std::mutex> guard(HandlerMutex);

		if (Handlers.joinGame)
			Handlers.joinGame(JoinGameSecret);
	}

	if (WasSpectateGame.exchange(false))
	{
		std::lock_guard<std::mutex> guard(HandlerMutex);

		if (Handlers.spectateGame)
			Handlers.spectateGame(SpectateGameSecret);
	}

	while (JoinAskQueue.HavePendingSends())
	{
		auto req = JoinAskQueue.GetNextSendMessage();

		{
			std::lock_guard<std::mutex> guard(HandlerMutex);

			if (Handlers.joinRequest)
			{
				DiscordUser du{req->userId,
					       req->username,
					       req->globalName,
					       req->discriminator,
					       req->avatar,
					       req->premiumType,
					       req->bot};

				Handlers.joinRequest(&du);
			}
		}

		JoinAskQueue.CommitSend();
	}

	if (!isConnected && wasDisconnected)
	{
		std::lock_guard<std::mutex> guard(HandlerMutex);

		if (Handlers.disconnected)
			Handlers.disconnected(LastDisconnectErrorCode, LastDisconnectErrorMessage);
	}
}

void Discord_UpdateHandlers(DiscordEventHandlers *newHandlers)
{
	if (newHandlers)
	{
		std::lock_guard<std::mutex> guard(HandlerMutex);

		if (!Handlers.joinGame && newHandlers->joinGame)
			RegisterForEvent("ACTIVITY_JOIN");
		else if (Handlers.joinGame && !newHandlers->joinGame)
			DeregisterForEvent("ACTIVITY_JOIN");

		if (!Handlers.spectateGame && newHandlers->spectateGame)
			RegisterForEvent("ACTIVITY_SPECTATE");
		else if (Handlers.spectateGame && !newHandlers->spectateGame)
			DeregisterForEvent("ACTIVITY_SPECTATE");

		if (!Handlers.joinRequest && newHandlers->joinRequest)
			RegisterForEvent("ACTIVITY_JOIN_REQUEST");
		else if (Handlers.joinRequest && !newHandlers->joinRequest)
			DeregisterForEvent("ACTIVITY_JOIN_REQUEST");

		Handlers = *newHandlers;
	}
	else
	{
		std::lock_guard<std::mutex> guard(HandlerMutex);

		Handlers = {};
	}
}
