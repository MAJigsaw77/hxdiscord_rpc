package;

import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

class Main
{
	public static function main():Void
	{
		var handlers:DiscordEventHandlers = DiscordEventHandlers.create();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize("345229890980937739", cpp.RawPointer.addressOf(handlers), 1, null);

		while (true)
		{
			#if HXDISCORD_RPC_DISABLE_IO_THREAD
                	Discord.UpdateConnection();
			#end
			Discord.RunCallbacks();
		}

		Discord.Shutdown();
	}

	static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestPtr:cpp.Star<DiscordUser> = cpp.ConstPointer.fromRaw(request).ptr;

		Sys.println('Discord: Connected to user ${requestPtr.username}#${requestPtr.discriminator}');

		var discordPresence:DiscordRichPresence = DiscordRichPresence.create();
        	discordPresence.state = "West of House";
        	discordPresence.details = "Frustration";
        	discordPresence.largeImageKey = "canary-large";
        	discordPresence.smallImageKey = "ptb-small";
        	discordPresence.partyId = "party1234";
        	discordPresence.partySize = 1;
        	discordPresence.partyMax = 6;
        	discordPresence.partyPrivacy = Discord.PARTY_PUBLIC;
        	discordPresence.matchSecret = "xyzzy";
        	discordPresence.joinSecret = "join";
        	discordPresence.spectateSecret = "look";
        	discordPresence.instance = 0;
        	Discord.UpdatePresence(cpp.RawPointer.addressOf(discordPresence));
	}

	static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		Sys.println('Discord: Disconnected (' + errorCode + ': ' + message + ')');
	}

	static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		Sys.println('Discord: Error (' + errorCode + ': ' + message + ')');
	}
}
