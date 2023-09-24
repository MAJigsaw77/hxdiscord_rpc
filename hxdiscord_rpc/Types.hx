package hxdiscord_rpc;

#if !cpp
#error 'Discord RPC supports only C++ target platforms.'
#end

class Types {} // blank

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:unreflective
@:structAccess
@:native('DiscordRichPresence')
extern class DiscordRichPresence
{
	@:native('DiscordRichPresence')
	static function create():DiscordRichPresence;

	var state:cpp.ConstCharStar; /* max 128 bytes */
	var details:cpp.ConstCharStar; /* max 128 bytes */
	var startTimestamp:cpp.Int64;
	var endTimestamp:cpp.Int64;
	var largeImageKey:cpp.ConstCharStar; /* max 32 bytes */
	var largeImageText:cpp.ConstCharStar; /* max 128 bytes */
	var smallImageKey:cpp.ConstCharStar; /* max 32 bytes */
	var smallImageText:cpp.ConstCharStar; /* max 128 bytes */
	var partyId:cpp.ConstCharStar; /* max 128 bytes */
	var partySize:Int;
	var partyMax:Int;
	var partyPrivacy:Int;
	var matchSecret:cpp.ConstCharStar; /* max 128 bytes */
	var joinSecret:cpp.ConstCharStar; /* max 128 bytes */
	var spectateSecret:cpp.ConstCharStar; /* max 128 bytes */
	var instance:cpp.Int8;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:unreflective
@:structAccess
@:native('DiscordUser')
extern class DiscordUser
{
	@:native('DiscordUser')
	static function create():DiscordUser;

	var userId:cpp.ConstCharStar;
	var username:cpp.ConstCharStar;
	var discriminator:cpp.ConstCharStar;
	var avatar:cpp.ConstCharStar;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:unreflective
@:structAccess
@:native('DiscordEventHandlers')
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
