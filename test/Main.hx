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

	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestPtr:cpp.Star<DiscordUser> = cpp.ConstPointer.fromRaw(request).ptr;

		Sys.println('Discord: Connected to User ${requestPtr.username}#${requestPtr.discriminator}');

		var discordPresence:DiscordRichPresence = DiscordRichPresence.create();
        	discordPresence.state = "West of House";
        	discordPresence.details = "Frustration";
        	discordPresence.largeImageKey = "canary-large";
        	discordPresence.smallImageKey = "ptb-small";
        	Discord.UpdatePresence(cpp.RawPointer.addressOf(discordPresence));
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		Sys.println('Discord: Disconnected (' + errorCode + ': ' + message + ')');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		Sys.println('Discord: Error (' + errorCode + ': ' + message + ')');
	}
}
