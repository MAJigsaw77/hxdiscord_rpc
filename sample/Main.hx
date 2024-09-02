package;

import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import sys.thread.Thread;

class Main
{
	public static function main():Void
	{
		final handlers:DiscordEventHandlers = DiscordEventHandlers.create();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize("345229890980937739", cpp.RawPointer.addressOf(handlers), 1, null);

		// Daemon Thread
		Thread.create(function():Void
		{
			while (true)
			{
				#if DISCORD_DISABLE_IO_THREAD
				Discord.UpdateConnection();
				#end
				Discord.RunCallbacks();

				// Wait 2 seconds until the next loop...
				Sys.sleep(2);
			}
		});

		Sys.sleep(20);

		Discord.Shutdown();
	}

	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		final username:String = request[0].username;
		final globalName:String = request[0].username;
		final discriminator:String = request[0].discriminator;

		if (Std.parseInt(cast(request[0].discriminator, String)) != 0)
			Sys.println('Discord: Connected to user ${username}#${discriminator} ($globalName)');
		else
			Sys.println('Discord: Connected to user @${username} ($globalName)');

		final discordPresence:DiscordRichPresence = DiscordRichPresence.create();
		discordPresence.state = "West of House";
		discordPresence.details = "Frustration";
		discordPresence.largeImageKey = "canary-large";
		discordPresence.smallImageKey = "ptb-small";

		final button:DiscordButton = DiscordButton.create();
		button.label = "Test 1";
		button.url = "https://example.com";
		discordPresence.buttons[0] = button;

		final button:DiscordButton = DiscordButton.create();
		button.label = "Test 2";
		button.url = "https://discord.gg/fortnite";
		discordPresence.buttons[1] = button;

		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		Sys.println('Discord: Disconnected ($errorCode:$message)');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		Sys.println('Discord: Error ($errorCode:$message)');
	}
}
