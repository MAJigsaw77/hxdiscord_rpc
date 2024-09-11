This is a **fork** of Discord RPC within the project, featuring several important bug fixes and new features.

### Bug Fixes

- Fixed a memory leak in `RegisterURL` on `MacOS`.
- Removed some unnecessary `lock_guard` to optimise performance.
- Implemented a check for `CFStringCreateWithCString` failures.
- Added `SOCK_CLOEXEC` and `FD_CLOEXEC` for Unix connections to enhance security.
- Added support for Discord's Snap package on Linux.
- Ensured missing fields default to empty strings.
- Removed redundant `assert` calls.

### New Features

- Added support for `ActivityType`.
- Expanded the `DiscordUser` structure to include `globalName`, `premiumType`, and `bot` attributes.
- Converted `partyPrivacy` into an enum for improved clarity.
- Introduced support for `buttons`.

These changes where mainly inspired by [this](https://github.com/harmonytf/discord-rpc) fork of Discord RPC.
