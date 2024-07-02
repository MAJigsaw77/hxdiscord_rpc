package hxdiscord_rpc;

/**
 * Dummy class for importing Discord RPC types.
 */
#if !cpp
#error 'Discord RPC supports only C++ target platforms.'
#end
class Types {}

/**
 * Represents rich presence information for Discord integration.
 */
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:unreflective
@:structAccess
@:native('DiscordRichPresence')
extern class DiscordRichPresence
{
	/**
	 * Creates a new instance.
	 *
	 * @return A new instance.
	 */
	@:native('DiscordRichPresence')
	static function create():DiscordRichPresence;

	/**
	 * State of the rich presence (max 128 bytes).
	 */
	var state:cpp.ConstCharStar;

	/**
	 * Details of the rich presence (max 128 bytes).
	 */
	var details:cpp.ConstCharStar;

	/**
	 * Start timestamp of the presence.
	 */
	var startTimestamp:cpp.Int64;

	/**
	 * End timestamp of the presence.
	 */
	var endTimestamp:cpp.Int64;

	/**
	 * Key for the large image asset (max 32 bytes).
	 */
	var largeImageKey:cpp.ConstCharStar;

	/**
	 * Text shown when hovering over the large image (max 128 bytes).
	 */
	var largeImageText:cpp.ConstCharStar;

	/**
	 * Key for the small image asset (max 32 bytes).
	 */
	var smallImageKey:cpp.ConstCharStar;

	/**
	 * Text shown when hovering over the small image (max 128 bytes).
	 */
	var smallImageText:cpp.ConstCharStar;

	/**
	 * ID of the party (max 128 bytes).
	 */
	var partyId:cpp.ConstCharStar;

	/**
	 * Current size of the party.
	 */
	var partySize:Int;

	/**
	 * Maximum size of the party.
	 */
	var partyMax:Int;

	/**
	 * Privacy setting for the party.
	 */
	var partyPrivacy:Int;

	/**
	 * Secret for matching (max 128 bytes).
	 */
	var matchSecret:cpp.ConstCharStar;

	/**
	 * Secret for joining (max 128 bytes).
	 */
	var joinSecret:cpp.ConstCharStar;

	/**
	 * Secret for spectating (max 128 bytes).
	 */
	var spectateSecret:cpp.ConstCharStar;

	/**
	 * Instance of the presence.
	 */
	var instance:cpp.Int8;
}

/**
 * Represents user information for Discord integration.
 */
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:unreflective
@:structAccess
@:native('DiscordUser')
extern class DiscordUser
{
	/**
	 * Creates a new instance.
	 *
	 * @return A new instance.
	 */
	@:native('DiscordUser')
	static function create():DiscordUser;

	/**
	 * ID of the user.
	 */
	var userId:cpp.ConstCharStar;

	/**
	 * Username of the user.
	 */
	var username:cpp.ConstCharStar;

	/**
	 * Discriminator of the user.
	 */
	var discriminator:cpp.ConstCharStar;

	/**
	 * Avatar of the user.
	 */
	var avatar:cpp.ConstCharStar;
}

/**
 * Represents event handlers for Discord integration.
 */
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:unreflective
@:structAccess
@:native('DiscordEventHandlers')
extern class DiscordEventHandlers
{
	/**
	 * Creates a new instance.
	 *
	 * @return A new instance.
	 */
	@:native('DiscordEventHandlers')
	static function create():DiscordEventHandlers;

	/**
	 * Callback for when the client becomes ready.
	 */
	var ready:cpp.Callable<(request:cpp.RawConstPointer<DiscordUser>) -> Void>;

	/**
	 * Callback for when the client disconnects.
	 */
	var disconnected:cpp.Callable<(errorCode:Int, message:cpp.ConstCharStar) -> Void>;

	/**
	 * Callback for when there is an error.
	 */
	var errored:cpp.Callable<(errorCode:Int, message:cpp.ConstCharStar) -> Void>;

	/**
	 * Callback for when the client should join a game.
	 */
	var joinGame:cpp.Callable<(joinSecret:cpp.ConstCharStar) -> Void>;

	/**
	 * Callback for when the client should spectate a game.
	 */
	var spectateGame:cpp.Callable<(spectateSecret:cpp.ConstCharStar) -> Void>;

	/**
	 * Callback for when the client receives a join request.
	 */
	var joinRequest:cpp.Callable<(request:cpp.RawConstPointer<DiscordUser>) -> Void>;
}
