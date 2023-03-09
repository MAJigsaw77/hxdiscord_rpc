package hxdiscord;

#if (!(desktop && cpp) && macro)
#error 'Discord RPC supports only C++ desktop target.'
#end

class Types {} // blank

@:include("discord_rpc.h")
@:keep
@:structAccess
@:native("DiscordRichPresence")
extern class DiscordRichPresence
{
	@:native('DiscordRichPresence')
	static function create():DiscordRichPresence;

	var state:String; /* max 128 bytes */
	var details:String; /* max 128 bytes */
	var startTimestamp:cpp.Int64;
	var endTimestamp:cpp.Int64;
	var largeImageKey:String; /* max 32 bytes */
	var largeImageText:String; /* max 128 bytes */
	var smallImageKey:String; /* max 32 bytes */
	var smallImageText:String; /* max 128 bytes */
	var partyId:String; /* max 128 bytes */
	var partySize:Int;
	var partyMax:Int;
	var partyPrivacy:Int;
	var matchSecret:String; /* max 128 bytes */
	var joinSecret:String; /* max 128 bytes */
	var spectateSecret:String; /* max 128 bytes */
	var instance:cpp.Int8;
}

@:include("discord_rpc.h")
@:keep
@:structAccess
@:native("DiscordUser")
extern class DiscordUser
{
	@:native('DiscordUser')
	static function create():DiscordUser;

	var userId:String;
	var username:String;
	var discriminator:String;
	var avatar:String;
}

@:include("discord_rpc.h")
@:keep
@:structAccess
@:native("DiscordEventHandlers")
extern class DiscordEventHandlers
{
	@:native('DiscordEventHandlers')
	static function create():DiscordEventHandlers;

	var ready:cpp.Callable<(request:cpp.RawConstPointer<DiscordUser>) -> Void>;
	var disconnected:cpp.Callable<(errorCode:Int, message:String) -> Void>;
	var errored:cpp.Callable<(errorCode:Int, message:String) -> Void>;
	var joinGame:cpp.Callable<(joinSecret:String) -> Void>;
	var spectateGame:cpp.Callable<(spectateSecret:String) -> Void>;
	var joinRequest:cpp.Callable<(request:cpp.RawConstPointer<DiscordUser>) -> Void>;
}
