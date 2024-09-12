#include "discord_rpc.hpp"

#include <stdio.h>
#include <sys/stat.h>

#import <AppKit/AppKit.h>

static void RegisterCommand(const char *applicationId, const char *command)
{
	// Note: will not work for sandboxed apps
	NSString *home = NSHomeDirectory();

	if (!home || [home length] == 0)
		return;

	NSString *path =
	    [[[[[[home stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Application Support"]
		stringByAppendingPathComponent:@"discord"] stringByAppendingPathComponent:@"games"]
		stringByAppendingPathComponent:[NSString stringWithUTF8String:applicationId]]
		stringByAppendingPathExtension:@"json"];

	[[NSFileManager defaultManager] createDirectoryAtPath:[path stringByDeletingLastPathComponent]
				  withIntermediateDirectories:YES
						   attributes:nil
							error:nil];

	NSString *jsonBuffer = [NSString stringWithFormat:@"{\"command\": \"%s\"}", command];
	[jsonBuffer writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

static void RegisterURL(const char *applicationId)
{
	char url[256];
	snprintf(url, sizeof(url), "discord-%s", applicationId);
	CFStringRef cfURL = CFStringCreateWithCString(NULL, url, kCFStringEncodingUTF8);

	if (!cfURL)
	{
		NSLog(@"Failure allocating URL CFString");
		return;
	}

	NSString *myBundleId = [[NSBundle mainBundle] bundleIdentifier];

	if (!myBundleId)
	{
		NSLog(@"No bundle id found");
		CFRelease(cfURL);
		return;
	}

	NSURL *myURL = [[NSBundle mainBundle] bundleURL];

	if (!myURL)
	{
		NSLog(@"No bundle url found");
		CFRelease(cfURL);
		return;
	}

	OSStatus status = LSSetDefaultHandlerForURLScheme(cfURL, (__bridge CFStringRef)myBundleId);

	if (status != noErr)
	{
		NSLog(@"Error in LSSetDefaultHandlerForURLScheme: %d", (int)status);
		CFRelease(cfURL);
		return;
	}

	status = LSRegisterURL((__bridge CFURLRef)myURL, true);

	if (status != noErr)
		NSLog(@"Error in LSRegisterURL: %d", (int)status);

	CFRelease(cfURL);
}

void Discord_Register(const char *applicationId, const char *command)
{
	if (command && command[0])
		RegisterCommand(applicationId, command);
	else
	{
		@autoreleasepool
		{
			RegisterURL(applicationId);
		}
	}
}

void Discord_RegisterSteamGame(const char *applicationId, const char *steamId)
{
	char command[256];
	snprintf(command, 256, "steam://rungameid/%s", steamId);
	Discord_Register(applicationId, command);
}
