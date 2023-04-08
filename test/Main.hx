package;

import hxdiscord.Discord;
import hxdiscord.Types;

class Main
{
	public static function main():Void
	{
		var handlers:DiscordEventHandlers = DiscordEventHandlers.create(); // ???
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize("345229890980937739", cpp.RawPointer.addressOf(handlers), 1, null);

		while (true)
		{
			#if DISCORD_DISABLE_IO_THREAD
                	Discord.UpdateConnection();
			#end
			Discord.RunCallbacks();
		}

		Discord.Shutdown();
	}

	static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestPtr:cpp.Star<DiscordUser> = cpp.ConstPointer.fromRaw(request).ptr;
		Sys.println('Discord: connected to user ' + requestPtr.username + '#' + requestPtr.discriminator + ' ' + requestPtr.userId);
	}

	static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
		Sys.println('Discord: disconnected (' + errorCode + ': ' + message + ')');

	static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
		Sys.println('Discord: error (' + errorCode + ': ' + message + ')');
}
