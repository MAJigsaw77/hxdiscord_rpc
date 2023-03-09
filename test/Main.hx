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
		handlers.joinGame = cpp.Function.fromStaticFunction(onJoin);
		handlers.spectateGame = cpp.Function.fromStaticFunction(onSpectate);
		handlers.joinRequest = cpp.Function.fromStaticFunction(onJoinRequest);

		Discord.Initialize("345229890980937739", cpp.RawPointer.addressOf(handlers), 1, null);

		while (true)
		{
                	// Discord.UpdateConnection();
			Discord.RunCallbacks();
		}

		Discord.Shutdown();
	}

	static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestRef:cpp.Star<DiscordUser> = cast request;
		Sys.println('Discord: connected to user ' + requestRef.username + '#' + requestRef.discriminator + '\n' + requestRef.userId);
	}

	static function onDisconnected(errorCode:Int, message:String):Void
		Sys.println('Discord: disconnected (' + errorCode + ': ' + message + ')');

	static function onError(errorCode:Int, message:String):Void
		Sys.println('Discord: error (' + errorCode + ': ' + message + ')');

	static function onJoin(joinSecret:String):Void
		Sys.println('Discord: join (' + joinSecret + ')');

	static function onSpectate(spectateSecret:String):Void
		Sys.println('Discord: spectate (' + spectateSecret + ')');

	static function onJoinRequest(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestRef:cpp.Star<DiscordUser> = cast request;
		Sys.println('Discord: join request from ' + requestRef.username + '#' + requestRef.discriminator + '\n' + requestRef.userId);
		Discord.Respond(requestRef.userId, Discord.REPLY_NO);
	}
}
