#pragma once

#include <stdbool.h>
#include <stdint.h>

#include "discord_rpc.hpp"
#include "rapidjson/document.h"
#include "rapidjson/stringbuffer.h"
#include "rapidjson/writer.h"

template <size_t Len> inline size_t StringCopy(char (&dest)[Len], const char *src)
{
	if (!src || !Len)
		return 0;

	size_t copied;
	char *out = dest;

	for (copied = 1; *src && copied < Len; ++copied)
		*out++ = *src++;

	*out = 0;
	return copied - 1;
}

template <size_t Len> inline size_t StringCopyOptional(char (&dest)[Len], const char *src)
{
	if (src)
		return StringCopy(dest, src);

	dest[0] = 0;
	return 0;
}

size_t JsonWriteHandshakeObj(char *dest, size_t maxLen, int version, const char *applicationId);

// Commands
struct DiscordRichPresence;

size_t JsonWriteRichPresenceObj(char *dest, size_t maxLen, int nonce, int pid, const DiscordRichPresence *presence);
size_t JsonWriteSubscribeCommand(char *dest, size_t maxLen, int nonce, const char *evtName);
size_t JsonWriteUnsubscribeCommand(char *dest, size_t maxLen, int nonce, const char *evtName);
size_t JsonWriteJoinReply(char *dest, size_t maxLen, const char *userId, DiscordActivityJoinRequestReply reply, int nonce);

class LinearAllocator
{
public:
	char *buffer_;
	char *end_;
	LinearAllocator()
	{
		assert(0);
	}
	LinearAllocator(char *buffer, size_t size) : buffer_(buffer), end_(buffer + size) {}
	static const bool kNeedFree = false;
	void *Malloc(size_t size)
	{
		char *res = buffer_;
		buffer_ += size;

		if (buffer_ > end_)
		{
			buffer_ = res;
			return nullptr;
		}

		return res;
	}
	void *Realloc(void *originalPtr, size_t originalSize, size_t newSize)
	{
		if (newSize == 0)
			return nullptr;

		assert(!originalPtr && !originalSize);

		(void)(originalPtr);
		(void)(originalSize);

		return Malloc(newSize);
	}
	static void Free(void *ptr)
	{
		(void)ptr;
	}
};

template <size_t Size> class FixedLinearAllocator : public LinearAllocator
{
public:
	char fixedBuffer_[Size];
	FixedLinearAllocator() : LinearAllocator(fixedBuffer_, Size) {}
	static const bool kNeedFree = false;
};

class DirectStringBuffer
{
public:
	using Ch = char;
	char *buffer_;
	char *end_;
	char *current_;

	DirectStringBuffer(char *buffer, size_t maxLen) : buffer_(buffer), end_(buffer + maxLen), current_(buffer) {}

	void Put(char c)
	{
		if (current_ < end_)
			*current_++ = c;
	}
	void Flush() {}
	size_t GetSize() const
	{
		return (size_t)(current_ - buffer_);
	}
};

using MallocAllocator = rapidjson::CrtAllocator;
using PoolAllocator = rapidjson::MemoryPoolAllocator<MallocAllocator>;
using UTF8 = rapidjson::UTF8<char>;
using StackAllocator = FixedLinearAllocator<2048>;
constexpr size_t WriterNestingLevels = 2048 / (2 * sizeof(size_t));
using JsonWriterBase = rapidjson::Writer<DirectStringBuffer, UTF8, UTF8, StackAllocator, rapidjson::kWriteNoFlags>;
class JsonWriter : public JsonWriterBase
{
public:
	DirectStringBuffer stringBuffer_;
	StackAllocator stackAlloc_;

	JsonWriter(char *dest, size_t maxLen)
	    : JsonWriterBase(stringBuffer_, &stackAlloc_, WriterNestingLevels), stringBuffer_(dest, maxLen), stackAlloc_()
	{
	}

	size_t Size() const
	{
		return stringBuffer_.GetSize();
	}
};

using JsonDocumentBase = rapidjson::GenericDocument<UTF8, PoolAllocator, StackAllocator>;
class JsonDocument : public JsonDocumentBase
{
public:
	char parseBuffer_[32768];

	MallocAllocator mallocAllocator_;
	PoolAllocator poolAllocator_;
	StackAllocator stackAllocator_;

	JsonDocument()
	    : JsonDocumentBase(rapidjson::kObjectType, &poolAllocator_, sizeof(stackAllocator_.fixedBuffer_), &stackAllocator_),
	      poolAllocator_(parseBuffer_, sizeof(parseBuffer_), 32768, &mallocAllocator_), stackAllocator_()
	{
	}
};

using JsonValue = rapidjson::GenericValue<UTF8, PoolAllocator>;

inline JsonValue *GetObjMember(JsonValue *obj, const char *name)
{
	if (obj)
	{
		auto member = obj->FindMember(name);

		if (member != obj->MemberEnd() && member->value.IsObject())
			return &member->value;
	}

	return nullptr;
}

inline int GetIntMember(JsonValue *obj, const char *name, int notFoundDefault = 0)
{
	if (obj)
	{
		auto member = obj->FindMember(name);

		if (member != obj->MemberEnd() && member->value.IsInt())
			return member->value.GetInt();
	}

	return notFoundDefault;
}

inline const char *GetStrMember(JsonValue *obj, const char *name, const char *notFoundDefault = nullptr)
{
	if (obj)
	{
		auto member = obj->FindMember(name);

		if (member != obj->MemberEnd() && member->value.IsString())
			return member->value.GetString();
	}

	return notFoundDefault;
}

inline bool GetBoolMember(JsonValue *obj, const char *name, bool notFoundDefault = false)
{
	if (obj)
	{
		auto member = obj->FindMember(name);

		if (member != obj->MemberEnd() && member->value.IsBool())
			return member->value.GetBool();
	}

	return notFoundDefault;
}
