#include "discord_rpc.hpp"

#include <windows.h>
#include <cstdio>
#include <psapi.h>

#ifdef __MINGW32__
#include <wchar.h>

static HRESULT StringCbPrintfW(LPWSTR pszDest, size_t cbDest, LPCWSTR pszFormat, ...)
{
	HRESULT ret;
	va_list va;
	va_start(va, pszFormat);
	cbDest /= 2;
	ret = vsnwprintf(pszDest, cbDest, pszFormat, va);
	pszDest[cbDest - 1] = 0;
	va_end(va);
	return ret;
}
#else
#include <cwchar>
#include <strsafe.h>
#endif

static void Discord_RegisterW(const wchar_t *applicationId, const wchar_t *command)
{
	wchar_t exeFilePath[MAX_PATH];
	DWORD exeLen = GetModuleFileNameW(nullptr, exeFilePath, MAX_PATH);

	wchar_t openCommand[1024];
	StringCbPrintfW(openCommand, sizeof(openCommand), L"%s", command && command[0] ? command : exeFilePath);

	wchar_t protocolName[64];
	StringCbPrintfW(protocolName, sizeof(protocolName), L"discord-%s", applicationId);

	wchar_t protocolDescription[128];
	StringCbPrintfW(protocolDescription, sizeof(protocolDescription), L"URL:Run game %s protocol", applicationId);

	wchar_t keyName[256];
	StringCbPrintfW(keyName, sizeof(keyName), L"Software\\Classes\\%s", protocolName);

	HKEY key;

	auto status = RegCreateKeyExW(HKEY_CURRENT_USER, keyName, 0, nullptr, 0, KEY_WRITE, nullptr, &key, nullptr);

	if (status != ERROR_SUCCESS)
	{
		fprintf(stderr, "Error creating key\n");
		return;
	}

	DWORD len = (DWORD)lstrlenW(protocolDescription) + 1;

	LSTATUS result = RegSetKeyValueW(key, nullptr, nullptr, REG_SZ, protocolDescription, len * sizeof(wchar_t));

	if (FAILED(result))
		fprintf(stderr, "Error writing description\n");

	len = (DWORD)lstrlenW(protocolDescription) + 1;

	wchar_t urlProtocol = 0;

	result = RegSetKeyValueW(key, nullptr, L"URL Protocol", REG_SZ, &urlProtocol, sizeof(wchar_t));

	if (FAILED(result))
		fprintf(stderr, "Error writing description\n");

	result = RegSetKeyValueW(key, L"DefaultIcon", nullptr, REG_SZ, exeFilePath, (exeLen + 1) * sizeof(wchar_t));

	if (FAILED(result))
		fprintf(stderr, "Error writing icon\n");

	len = (DWORD)lstrlenW(openCommand) + 1;

	result = RegSetKeyValueW(key, L"shell\\open\\command", nullptr, REG_SZ, openCommand, len * sizeof(wchar_t));

	if (FAILED(result))
		fprintf(stderr, "Error writing command\n");

	RegCloseKey(key);
}

void Discord_Register(const char *applicationId, const char *command)
{
	wchar_t appId[32];

	MultiByteToWideChar(CP_UTF8, 0, applicationId, -1, appId, 32);

	wchar_t openCommand[1024];

	const wchar_t *wcommand = nullptr;

	if (command && command[0])
	{
		const auto commandBufferLen = sizeof(openCommand) / sizeof(*openCommand);
		MultiByteToWideChar(CP_UTF8, 0, command, -1, openCommand, commandBufferLen);
		wcommand = openCommand;
	}

	Discord_RegisterW(appId, wcommand);
}

void Discord_RegisterSteamGame(const char *applicationId, const char *steamId)
{
	wchar_t appId[32];
	MultiByteToWideChar(CP_UTF8, 0, applicationId, -1, appId, 32);

	wchar_t wSteamId[32];
	MultiByteToWideChar(CP_UTF8, 0, steamId, -1, wSteamId, 32);

	HKEY key;

	auto status = RegOpenKeyExW(HKEY_CURRENT_USER, L"Software\\Valve\\Steam", 0, KEY_READ, &key);

	if (status != ERROR_SUCCESS)
	{
		fprintf(stderr, "Error opening Steam key\n");
		return;
	}

	wchar_t steamPath[MAX_PATH];

	DWORD pathBytes = sizeof(steamPath);

	status = RegQueryValueExW(key, L"SteamExe", nullptr, nullptr, (BYTE *)steamPath, &pathBytes);

	RegCloseKey(key);

	if (status != ERROR_SUCCESS || pathBytes < 1)
	{
		fprintf(stderr, "Error reading SteamExe key\n");
		return;
	}

	DWORD pathChars = pathBytes / sizeof(wchar_t);

	for (DWORD i = 0; i < pathChars; ++i)
	{
		if (steamPath[i] == L'/')
			steamPath[i] = L'\\';
	}

	wchar_t command[1024];
	StringCbPrintfW(command, sizeof(command), L"\"%s\" steam://rungameid/%s", steamPath, wSteamId);
	Discord_RegisterW(appId, command);
}
