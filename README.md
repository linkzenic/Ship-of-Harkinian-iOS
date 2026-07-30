# Ship of Harkinian - iOS

Linkzenic's iPhone, iPad, and Apple TV port of
[Ship of Harkinian](https://github.com/HarbourMasters/Shipwright).

This project follows the Linkzenic SOH feature set and menus while adapting
display, storage, touch controls, controllers, and first-run setup for Apple
devices.

## Downloads

Test builds are published on the
[Releases page](https://github.com/linkzenic/Ship-of-Harkinian-iOS/releases).

Public IPA files do not contain copyrighted game data. A legally obtained,
supported Ocarina of Time ROM is required. Depending on the release type, users
may need to sign the IPA with their own Apple developer identity or sideloading
service before installation.

## Platforms

- iPhone and iPad
- Apple TV
- macOS support is planned

## Current Apple Features

- Native iPhone and iPad display sizing and safe-area handling
- Linkzenic touch controls and physical controller support
- Controller-first Apple TV navigation
- Local-network game-data transfer for Apple TV
- Optional CloudKit synchronization for save files
- Local storage for settings, mods, archives, and device-specific configuration

## Building

See [docs/IOS_PORT.md](docs/IOS_PORT.md) for the current build and platform
notes. Xcode and the Apple platform SDKs are required.

Build and package an unsigned iPhone IPA with:

```sh
scripts/build-ios.sh --device
scripts/package-ios-unsigned.sh
```

Build and package an unsigned Apple TV IPA with:

```sh
scripts/build-ios.sh --tvos-device
scripts/package-ios-unsigned.sh \
  "build-tvos-device/soh/Release-appletvos/Ship of Harkinian.app" \
  "dist/Ship-of-Harkinian-tvOS-unsigned.ipa"
```

The packaging step rejects executables containing a local `/Users/` build path
and removes any stale code signature or embedded provisioning profile.

## Project Attribution

Ship of Harkinian is developed by Harbour Masters and its contributors. This is
an unofficial platform port and is not affiliated with Nintendo.
