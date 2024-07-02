package hxdiscord_rpc;

/**
 * Dummy class for importing Discord RPC types.
 */
#if !cpp
#error 'Discord RPC supports only C++ target platforms.'
#end
class Types {}

@:dox(hide)
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:unreflective
@:structAccess
@:native('DiscordRichPresence')
extern class DiscordRichPresence
{
	@:native('DiscordRichPresence')
	static function create():DiscordRichPresence;

	var state:cpp.ConstCharStar;
	var details:cpp.ConstCharStar;
	var startTimestamp:cpp.Int64;
	var endTimestamp:cpp.Int64;
	var largeImageKey:cpp.ConstCharStar;
	var largeImageText:cpp.ConstCharStar;
	var smallImageKey:cpp.ConstCharStar;
	var smallImageText:cpp.ConstCharStar;
	var partyId:cpp.ConstCharStar;
	var partySize:Int;
	var partyMax:Int;
	var partyPrivacy:Int;
	var matchSecret:cpp.ConstCharStar;
	var joinSecret:cpp.ConstCharStar;
	var spectateSecret:cpp.ConstCharStar;
	var instance:cpp.Int8;
}

@:dox(hide)
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

@:dox(hide)
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
