#pragma once

#include <atomic>

template <typename ElementType, size_t QueueSize> class MsgQueue
{
	ElementType queue_[QueueSize];
	std::atomic_uint nextAdd_{0};
	std::atomic_uint nextSend_{0};
	std::atomic_uint pendingSends_{0};

public:
	MsgQueue() {}

	ElementType *GetNextAddMessage()
	{
		if (pendingSends_.load() >= QueueSize)
			return nullptr;

		auto index = (nextAdd_++) % QueueSize;

		return &queue_[index];
	}
	void CommitAdd()
	{
		++pendingSends_;
	}
	bool HavePendingSends() const
	{
		return pendingSends_.load() != 0;
	}
	ElementType *GetNextSendMessage()
	{
		auto index = (nextSend_++) % QueueSize;

		return &queue_[index];
	}
	void CommitSend()
	{
		--pendingSends_;
	}
};
