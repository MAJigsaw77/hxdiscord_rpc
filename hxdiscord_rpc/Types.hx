package hxdiscord_rpc;

#if (!cpp && macro)
#error 'Discord RPC supports only C++ target.'
#end

class Types {} // blank

@:buildXml("<include name='${haxelib:hxdiscord_rpc}/project/Build.xml' />")
@:include("discord_rpc.h")
@:keep
@:structAccess
@:native("DiscordRichPresence")
extern class DiscordRichPresence
{
	@:native('DiscordRichPresence')
	static function create():DiscordRichPresence;

	var state:ConstCharStar; /* max 128 bytes */
	var details:ConstCharStar; /* max 128 bytes */
	var startTimestamp:cpp.Int64;
	var endTimestamp:cpp.Int64;
	var largeImageKey:ConstCharStar; /* max 32 bytes */
	var largeImageText:ConstCharStar; /* max 128 bytes */
	var smallImageKey:ConstCharStar; /* max 32 bytes */
	var smallImageText:ConstCharStar; /* max 128 bytes */
	var partyId:ConstCharStar; /* max 128 bytes */
	var partySize:Int;
	var partyMax:Int;
	var partyPrivacy:Int;
	var matchSecret:ConstCharStar; /* max 128 bytes */
	var joinSecret:ConstCharStar; /* max 128 bytes */
	var spectateSecret:ConstCharStar; /* max 128 bytes */
	var instance:cpp.Int8;
}

@:buildXml("<include name='${haxelib:hxdiscord_rpc}/project/Build.xml' />")
@:include("discord_rpc.h")
@:keep
@:structAccess
@:native("DiscordUser")
extern class DiscordUser
{
	@:native('DiscordUser')
	static function create():DiscordUser;

	var userId:ConstCharStar;
	var username:ConstCharStar;
	var discriminator:ConstCharStar;
	var avatar:ConstCharStar;
}

@:buildXml("<include name='${haxelib:hxdiscord_rpc}/project/Build.xml' />")
@:include("discord_rpc.h")
@:keep
@:structAccess
@:native("DiscordEventHandlers")
extern class DiscordEventHandlers
{
	@:native('DiscordEventHandlers')
	static function create():DiscordEventHandlers;

	var ready:cpp.Callable<(request:cpp.RawConstPointer<DiscordUser>) -> Void>;
	var disconnected:cpp.Callable<(errorCode:Int, message:cpp.ConstCharStar) -> Void>;
	var errored:cpp.Callable<(errorCode:Int, message:cpp.ConstCharStar) -> Void>;
	var joinGame:cpp.Callable<(joinSecret:cpp.ConstCharStar) -> Void>;
	var spectateGame:cpp.Callable<(spectateSecret:cpp.ConstCharStar) -> Void>;
	var joinRequest:cpp.Callable<(request:cpp.RawConstPointer<DiscordUser>) -> Void>;
}
