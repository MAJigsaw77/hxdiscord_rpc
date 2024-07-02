package hxdiscord_rpc;

#if !cpp
#error 'Discord RPC supports only C++ target platforms.'
#end
import hxdiscord_rpc.Types;

/**
 * This class provides static methods to interact with the Discord RPC (Rich Presence) API.
 * It facilitates integration with Discord's rich presence functionality,
 * enabling applications to display real-time information about the user's status.
 * Methods are available for initializing the API, updating presence, handling callbacks,
 * and managing connection settings.
 */
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:include('discord_register.h')
@:unreflective
extern class Discord
{
	/**
	 * No reply constant.
	 */
	@:native('DISCORD_REPLY_NO')
	static var REPLY_NO:Int;

	/**
	 * Yes reply constant.
	 */
	@:native('DISCORD_REPLY_YES')
	static var REPLY_YES:Int;

	/**
	 * Ignore reply constant.
	 */
	@:native('DISCORD_REPLY_IGNORE')
	static var REPLY_IGNORE:Int;

	/**
	 * Private party constant.
	 */
	@:native('DISCORD_PARTY_PRIVATE')
	static var PARTY_PRIVATE:Int;

	/**
	 * Public party constant.
	 */
	@:native('DISCORD_PARTY_PUBLIC')
	static var PARTY_PUBLIC:Int;

	/**
	 * Initializes the Discord RPC.
	 *
	 * @param applicationId The application ID for the Discord app.
	 * @param handlers Pointer to a DiscordEventHandlers struct containing event callbacks.
	 * @param autoRegister Indicates whether to automatically register the application.
	 * @param optionalSteamId Optional Steam ID if using Steam.
	 */
	@:native('Discord_Initialize')
	static function Initialize(applicationId:cpp.ConstCharStar, handlers:cpp.RawPointer<DiscordEventHandlers>, autoRegister:Int,
		optionalSteamId:cpp.ConstCharStar):Void;

	/**
	 * Shuts down the Discord RPC.
	 */
	@:native('Discord_Shutdown')
	static function Shutdown():Void;

	/**
	 * Checks for incoming messages and dispatches callbacks.
	 */
	@:native('Discord_RunCallbacks')
	static function RunCallbacks():Void;

	#if DISCORD_DISABLE_IO_THREAD
	/**
	 * Updates the connection.
	 * Note: This should be called if the library is configured not to start its own IO thread.
	 */
	@:native('Discord_UpdateConnection')
	static function UpdateConnection():Void;
	#end

	/**
	 * Updates the current presence.
	 *
	 * @param presence Pointer to a DiscordRichPresence struct containing the presence information.
	 */
	@:native('Discord_UpdatePresence')
	static function UpdatePresence(presence:cpp.RawConstPointer<DiscordRichPresence>):Void;

	/**
	 * Clears the current presence.
	 */
	@:native('Discord_ClearPresence')
	static function ClearPresence():Void;

	/**
	 * Responds to a user's request.
	 *
	 * @param userid The user ID to respond to.
	 * @param reply The reply type (either REPLY_NO, REPLY_YES, or REPLY_IGNORE).
	 */
	@:native('Discord_Respond')
	static function Respond(userid:cpp.ConstCharStar, reply:Int):Void;

	/**
	 * Updates the event handlers.
	 *
	 * @param handlers Pointer to a DiscordEventHandlers struct containing event callbacks.
	 */
	@:native('Discord_UpdateHandlers')
	static function UpdateHandlers(handlers:cpp.RawPointer<DiscordEventHandlers>):Void;

	/**
	 * Registers the application.
	 *
	 * @param applicationId The application ID for the Discord app.
	 * @param command The command to register.
	 */
	@:native('Discord_Register')
	static function Register(applicationId:cpp.ConstCharStar, command:cpp.ConstCharStar):Void;

	/**
	 * Registers a Steam game.
	 *
	 * @param applicationId The application ID for the Discord app.
	 * @param steamId The Steam ID for the game.
	 */
	@:native('Discord_RegisterSteamGame')
	static function RegisterSteamGame(applicationId:cpp.ConstCharStar, steamId:cpp.ConstCharStar):Void;
}
