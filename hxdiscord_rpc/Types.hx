package hxdiscord_rpc;

/**
 * Dummy class for importing Discord RPC types.
 */
#if !cpp
#error 'Discord RPC supports only C++ target platforms.'
#end
class Types {}

extern enum abstract DiscordPremiumType(DiscordPremiumType_Impl)
{
	@:native('DiscordPremiumType_None')
	var DiscordPremiumType_None;

	@:native('DiscordPremiumType_Tier1')
	var DiscordPremiumType_Tier1;

	@:native('DiscordPremiumType_Tier2')
	var DiscordPremiumType_Tier2;

	@:from
	static public inline function fromInt(i:Int):LibVLC_Audio_Output_Channel_T
		return cast i;

	@:to extern public inline function toInt():Int
		return untyped this;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:native('DiscordPremiumType')
private extern class DiscordPremiumType_Impl {}

extern enum abstract DiscordActivityPartyPrivacy(DiscordActivityPartyPrivacy_Impl)
{
	@:native('DiscordActivityPartyPrivacy_Private')
	var DiscordActivityPartyPrivacy_Private;

	@:native('DiscordActivityPartyPrivacy_Public')
	var DiscordActivityPartyPrivacy_Public;

	@:from
	static public inline function fromInt(i:Int):DiscordActivityPartyPrivacy
		return cast i;

	@:to extern public inline function toInt():Int
		return untyped this;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:native('DiscordActivityPartyPrivacy')
private extern class DiscordActivityPartyPrivacy_Impl {}

extern enum abstract DiscordActivityType(DiscordActivityType_Impl)
{
	@:native('DiscordActivityType_Playing')
	var DiscordActivityType_Playing;

	@:native('DiscordActivityType_Streaming')
	var DiscordActivityType_Streaming;

	@:native('DiscordActivityType_Listening')
	var DiscordActivityType_Listening;

	@:native('DiscordActivityType_Watching')
	var DiscordActivityType_Watching;

	@:from
	static public inline function fromInt(i:Int):DiscordActivityType
		return cast i;

	@:to extern public inline function toInt():Int
		return untyped this;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:native('DiscordActivityType')
private extern class DiscordActivityType_Impl {}

extern enum abstract DiscordActivityJoinRequestReply(DiscordActivityJoinRequestReply_Impl)
{
	@:native('DiscordActivityJoinRequestReply_No')
	var DiscordActivityJoinRequestReply_No;

	@:native('DiscordActivityJoinRequestReply_Yes')
	var DiscordActivityJoinRequestReply_Yes;

	@:native('DiscordActivityJoinRequestReply_Ignore')
	var DiscordActivityJoinRequestReply_Ignore;

	@:from
	static public inline function fromInt(i:Int):DiscordActivityJoinRequestReply
		return cast i;

	@:to extern public inline function toInt():Int
		return untyped this;
}

@:buildXml('<include name="${haxelib:hxdiscord_rpc}/project/Build.xml" />')
@:include('discord_rpc.h')
@:native('DiscordActivityJoinRequestReply')
private extern class DiscordActivityJoinRequestReply_Impl {}

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
	 * Type of activity of the rich presence.
	 */
	var type:DiscordActivityType;

	/**
	 * Stream URL of the rich presence (max 512 bytes).
	 */
	var url:cpp.ConstCharStar;

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
	var partyPrivacy:DiscordActivityPartyPrivacy;

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
	 * Whether this is an instance of the presence.
	 */
	var instance:Bool;
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
	 * Global name of the user.
	 */
	var globalName:cpp.ConstCharStar;

	/**
	 * Discriminator of the user.
	 */
	var discriminator:cpp.ConstCharStar;

	/**
	 * Avatar of the user.
	 */
	var avatar:cpp.ConstCharStar;

	/**
	 * Premium type of the user.
	 */
	var premiumType:DiscordPremiumType;

	/**
	 * Whether the user is a bot.
	 */
	var bot:Bool;
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
