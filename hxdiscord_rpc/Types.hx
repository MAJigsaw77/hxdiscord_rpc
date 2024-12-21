package hxdiscord_rpc;

/**
 * Dummy class for importing Discord RPC types.
 */
#if !cpp
#error 'Discord RPC supports only C++ target platforms.'
#end
class Types {}

/**
 * Represents different types of Discord premium memberships.
 */
extern enum abstract DiscordPremiumType(DiscordPremiumType_Impl)
{
	/**
	 * No premium membership.
	 */
	@:native('DiscordPremiumType_None')
	var DiscordPremiumType_None;

	/**
	 * Nitro classic premium membership.
	 */
	@:native('DiscordPremiumType_NitroClassic')
	var DiscordPremiumType_NitroClassic;

	/**
	 * Nitro premium membership.
	 */
	@:native('DiscordPremiumType_Nitro')
	var DiscordPremiumType_Nitro;

	/**
	 * Nitro basic premium membership.
	 */
	@:native('DiscordPremiumType_NitroBasic')
	var DiscordPremiumType_NitroBasic;

	@:from
	static public inline function fromInt(i:Int):DiscordPremiumType
		return cast i;

	@:to extern public inline function toInt():Int
		return untyped this;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.hpp')
@:native('DiscordPremiumType')
private extern class DiscordPremiumType_Impl {}

/**
 * Represents the privacy settings for a Discord activity party.
 */
extern enum abstract DiscordActivityPartyPrivacy(DiscordActivityPartyPrivacy_Impl)
{
	/**
	 * The party is private and only visible to invited users.
	 */
	@:native('DiscordActivityPartyPrivacy_Private')
	var DiscordActivityPartyPrivacy_Private;

	/**
	 * The party is public and visible to everyone.
	 */
	@:native('DiscordActivityPartyPrivacy_Public')
	var DiscordActivityPartyPrivacy_Public;

	@:from
	static public inline function fromInt(i:Int):DiscordActivityPartyPrivacy
		return cast i;

	@:to extern public inline function toInt():Int
		return untyped this;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.hpp')
@:native('DiscordActivityPartyPrivacy')
private extern class DiscordActivityPartyPrivacy_Impl {}

/**
 * Represents different types of Discord activities.
 */
extern enum abstract DiscordActivityType(DiscordActivityType_Impl)
{
	/**
	 * The activity is playing a game.
	 */
	@:native('DiscordActivityType_Playing')
	var DiscordActivityType_Playing;

	/**
	 * The activity is listening to music.
	 */
	@:native('DiscordActivityType_Listening')
	var DiscordActivityType_Listening;

	/**
	 * The activity is watching a video.
	 */
	@:native('DiscordActivityType_Watching')
	var DiscordActivityType_Watching;

	/**
	 * The activity is competing.
	 */
	@:native('DiscordActivityType_Competing')
	var DiscordActivityType_Competing;

	@:from
	static public inline function fromInt(i:Int):DiscordActivityType
		return cast i;

	@:to extern public inline function toInt():Int
		return untyped this;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.hpp')
@:native('DiscordActivityType')
private extern class DiscordActivityType_Impl {}

/**
 * Represents different replies to a Discord activity join request.
 */
extern enum abstract DiscordActivityJoinRequestReply(DiscordActivityJoinRequestReply_Impl)
{
	/**
	 * The join request was denied.
	 */
	@:native('DiscordActivityJoinRequestReply_No')
	var DiscordActivityJoinRequestReply_No;

	/**
	 * The join request was accepted.
	 */
	@:native('DiscordActivityJoinRequestReply_Yes')
	var DiscordActivityJoinRequestReply_Yes;

	/**
	 * The join request was ignored.
	 */
	@:native('DiscordActivityJoinRequestReply_Ignore')
	var DiscordActivityJoinRequestReply_Ignore;

	@:from
	static public inline function fromInt(i:Int):DiscordActivityJoinRequestReply
		return cast i;

	@:to extern public inline function toInt():Int
		return untyped this;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.hpp')
@:native('DiscordActivityJoinRequestReply')
private extern class DiscordActivityJoinRequestReply_Impl {}

/**
 * Represents a button for Discord Rich Presence.
 */
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.hpp')
@:unreflective
@:structAccess
@:native('DiscordButton')
extern class DiscordButton
{
	/**
	 * Creates a new instance.
	 */
	function new():Void;

	/**
	 * The label of the button that is displayed to users.
	 */
	var label:cpp.ConstCharStar;

	/**
	 * The URL associated with the button.
	 */
	var url:cpp.ConstCharStar;
}

/**
 * Represents rich presence information for Discord integration.
 */
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.hpp')
@:unreflective
@:structAccess
@:native('DiscordRichPresence')
extern class DiscordRichPresence
{
	/**
	 * Creates a new instance.
	 */
	function new():Void;

	/**
	 * Type of activity of the rich presence.
	 */
	var type:DiscordActivityType;

	/**
	 * State of the rich presence (max 128 bytes).
	 */
	var state:cpp.ConstCharStar;

	/**
	 * Details of the rich presence (max 128 bytes).
	 */
	var details:cpp.ConstCharStar;

	/**
	 * Start timestamp of the rich presence.
	 */
	var startTimestamp:cpp.Int64;

	/**
	 * End timestamp of the rich presence.
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
	var partyPrivacy:DiscordActivityPartyPrivacy;

	/**
	 * Buttons of the rich presence (max 2 elements).
	 */
	var buttons:cpp.RawPointer<DiscordButton>;

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
	 * Whether this is an instance of the rich presence.
	 */
	var instance:Bool;
}

/**
 * Represents user information for Discord integration.
 */
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.hpp')
@:unreflective
@:structAccess
@:native('DiscordUser')
extern class DiscordUser
{
	/**
	 * Creates a new instance.
	 */
	function new():Void;

	/**
	 * ID of the user.
	 */
	var userId:cpp.ConstCharStar;

	/**
	 * Username of the user.
	 */
	var username:cpp.ConstCharStar;

	/**
	 * Global name of the user.
	 */
	var globalName:cpp.ConstCharStar;

	/**
	 * Discord-tag of the user.
	 */
	var discriminator:cpp.ConstCharStar;

	/**
	 * Avatar hash of the user.
	 */
	var avatar:cpp.ConstCharStar;

	/**
	 * Type of Nitro subscription the user has.
	 */
	var premiumType:DiscordPremiumType;

	/**
	 * Whether the user belongs to an OAuth2 application.
	 */
	var bot:Bool;
}

/**
 * Represents event handlers for Discord integration.
 */
@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.hpp')
@:unreflective
@:structAccess
@:native('DiscordEventHandlers')
extern class DiscordEventHandlers
{
	/**
	 * Creates a new instance.
	 */
	function new():Void;

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
