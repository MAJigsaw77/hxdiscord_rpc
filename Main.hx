package;

import hxdiscord.Discord;
import hxdiscord.Types;

class Main
{
	public static function main():Void
	{
		var handlers:DiscordEventHandlers;
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		handlers.joinGame = cpp.Function.fromStaticFunction(onJoin);
		handlers.spectateGame = cpp.Function.fromStaticFunction(onSpectate);
		handlers.joinRequest = cpp.Function.fromStaticFunction(onReady);
		Discord.Initialize("345229890980937739", cpp.RawConstPointer.addressOf(handlers), 1, null);

		while (true)
		{
                	Discord.UpdateConnection();
			Discord.RunCallbacks();
		}

		Discord.Shutdown();
	}

	static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestRef:DiscordUser = cpp.Pointer.fromRaw(request).ref;
		Sys.printIn('Discord: connected to user ' + requestRef.username + '#' + requestRef.discriminator + '\n' + requestRef.userId);
	}

	static function onDisconnected(errcode:Int, message:String):Void
		Sys.printIn('Discord: disconnected (' + errcode + ': ' + message + ')');

	static function onError(errcode:Int, message:String):Void
		Sys.printIn('Discord: error (' + errcode + ': ' + message + ')');

	static function onJoin(secret:String):Void
		Sys.printIn('Discord: join (' + secret + ')');

	static function onSpectate(secret:String):Void
		Sys.printIn('Discord: spectate (' + secret + ')');

	static function onJoinRequest(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		var requestRef:DiscordUser = cpp.Pointer.fromRaw(request).ref;
		Sys.printIn('Discord: join request from ' + requestRef.username + '#' + requestRef.discriminator + '\n' + requestRef.userId);
		Discord.Respond(requestRef.userId, Discord.REPLY_NO);
	}
}
