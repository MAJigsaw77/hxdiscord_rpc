#pragma once

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif

	typedef enum DiscordPremiumType
	{
		DiscordPremiumType_None,
		DiscordPremiumType_NitroClassic,
		DiscordPremiumType_Nitro,
		DiscordPremiumType_NitroBasic
	} DiscordPremiumType;

	typedef enum DiscordActivityPartyPrivacy
	{
		DiscordActivityPartyPrivacy_Private,
		DiscordActivityPartyPrivacy_Public
	} DiscordActivityPartyPrivacy;

	typedef enum DiscordActivityType
	{
		DiscordActivityType_Playing = 0,
		DiscordActivityType_Listening = 2,
		DiscordActivityType_Watching = 3,
		DiscordActivityType_Competing = 5
	} DiscordActivityType;

	typedef enum DiscordActivityJoinRequestReply
	{
		DiscordActivityJoinRequestReply_No,
		DiscordActivityJoinRequestReply_Yes,
		DiscordActivityJoinRequestReply_Ignore
	} DiscordActivityJoinRequestReply;

	typedef struct DiscordButton
	{
		const char *label;
		const char *url;
	} DiscordButton;

	typedef struct DiscordRichPresence
	{
		DiscordActivityType type;
		const char *state;   /* max 128 bytes */
		const char *details; /* max 128 bytes */
		int64_t startTimestamp;
		int64_t endTimestamp;
		const char *largeImageKey;  /* max 32 bytes */
		const char *largeImageText; /* max 128 bytes */
		const char *smallImageKey;  /* max 32 bytes */
		const char *smallImageText; /* max 128 bytes */
		const char *partyId;	    /* max 128 bytes */
		int partySize;
		int partyMax;
		DiscordActivityPartyPrivacy partyPrivacy;
		DiscordButton buttons[2];   /* max 2 elements */
		const char *matchSecret;    /* max 128 bytes */
		const char *joinSecret;	    /* max 128 bytes */
		const char *spectateSecret; /* max 128 bytes */
		bool instance;
	} DiscordRichPresence;

	typedef struct DiscordUser
	{
		const char *userId;
		const char *username;
		const char *globalName;
		const char *discriminator;
		const char *avatar;
		DiscordPremiumType premiumType;
		bool bot;
	} DiscordUser;

	typedef struct DiscordEventHandlers
	{
		void (*ready)(const DiscordUser *request);
		void (*disconnected)(int errorCode, const char *message);
		void (*errored)(int errorCode, const char *message);
		void (*joinGame)(const char *joinSecret);
		void (*spectateGame)(const char *spectateSecret);
		void (*joinRequest)(const DiscordUser *request);
	} DiscordEventHandlers;

	void Discord_Register(const char *applicationId, const char *command);
	void Discord_RegisterSteamGame(const char *applicationId, const char *steamId);
	void Discord_Initialize(const char *applicationId,
				DiscordEventHandlers *handlers,
				int autoRegister,
				const char *optionalSteamId);
	void Discord_Shutdown(void);
	void Discord_RunCallbacks(void);
#ifdef DISCORD_DISABLE_IO_THREAD
	void Discord_UpdateConnection(void);
#endif
	void Discord_UpdatePresence(const DiscordRichPresence *presence);
	void Discord_ClearPresence(void);
	void Discord_Respond(const char *userid, DiscordActivityJoinRequestReply reply);
	void Discord_UpdateHandlers(DiscordEventHandlers *handlers);

#ifdef __cplusplus
} /* extern "C" */
#endif
