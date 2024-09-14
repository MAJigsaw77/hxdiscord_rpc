#include "discord_rpc.hpp"

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static bool Mkdir(const char *path)
{
	return mkdir(path, 0755) == 0 || errno == EEXIST;
}

void Discord_Register(const char *applicationId, const char *command)
{
	const char *home = getenv("HOME");

	if (!home || !home[0])
		return;

	if (!command || !command[0])
	{
		char exePath[PATH_MAX];

		ssize_t length = readlink("/proc/self/exe", exePath, sizeof(exePath) - 1);

		if (length < 0)
			command = getenv("_");
		else
		{
			exePath[length] = '\0';

			command = exePath;
		}
	}

	const char *desktopFileFormat = "[Desktop Entry]\n"
					"Name=Game %s\n"
					"Exec=%s %%u\n"
					"Type=Application\n"
					"NoDisplay=true\n"
					"Categories=Discord;Games;\n"
					"MimeType=x-scheme-handler/discord-%s;\n";

	char desktopFile[2048];
	int fileLen = snprintf(desktopFile, sizeof(desktopFile), desktopFileFormat, applicationId, command, applicationId);
	if (fileLen <= 0)
		return;

	char desktopFilename[256];
	snprintf(desktopFilename, sizeof(desktopFilename), "/discord-%s.desktop", applicationId);

	char desktopFilePath[1024];

	snprintf(desktopFilePath, sizeof(desktopFilePath), "%s/.local", home);
	if (!Mkdir(desktopFilePath))
		return;

	strcat(desktopFilePath, "/share");
	if (!Mkdir(desktopFilePath))
		return;

	strcat(desktopFilePath, "/applications");
	if (!Mkdir(desktopFilePath))
		return;

	strcat(desktopFilePath, desktopFilename);

	FILE *fp = fopen(desktopFilePath, "w");

	if (fp)
	{
		fwrite(desktopFile, 1, fileLen, fp);
		fclose(fp);
	}
	else
		return;

	char xdgMimeCommand[1024];
	snprintf(xdgMimeCommand,
		 sizeof(xdgMimeCommand),
		 "xdg-mime default discord-%s.desktop x-scheme-handler/discord-%s",
		 applicationId,
		 applicationId);

	if (system(xdgMimeCommand) < 0)
		fprintf(stderr, "Failed to register mime handler\n");
}

void Discord_RegisterSteamGame(const char *applicationId, const char *steamId)
{
	char command[256];
	sprintf(command, "xdg-open steam://rungameid/%s", steamId);
	Discord_Register(applicationId, command);
}
