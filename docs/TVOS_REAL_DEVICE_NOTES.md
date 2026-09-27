# tvOS Real-Device Notes

This document records bring-up work for the existing Apple-platform fork. It is
intended to be updated after each physical-device test.

## Scope

The repository is the Apple-platform fork at:

`https://github.com/linkzenic/Ship-of-Harkinian-iOS`

No upstream tvOS port was started. No ROM or extracted Nintendo game data is
stored in the repository.

## Baseline

Initial repository commit:

`221107288d1099a77366c589313b67b5a544805c`

Submodules at baseline:

- OTRExporter: `77d47bc6d1767edb56f7cd461c5e1b7681f36a93`
- ZAPDTR: `6691524148aee49080372f6163099f18284edcf7`
- libultraship: `2495bc4de75af24ba6cdd0e8301dd3bb2bce21b0`

The working branch is `tvos-device-validation`. Repository status was clean
before build bring-up.

Host environment recorded on 2026-09-26:

- Xcode 27.0 (`27A266`)
- macOS 27.0 (`26A428`)
- CMake 4.0.3
- Python 3.14.6
- Ninja is not installed
- tvOS SDK 27.0
- The generated device build targets arm64 tvOS 15.0

## Existing tvOS implementation findings

The fork already contains tvOS-specific code for the requested areas:

- `soh/ios/SOHTVOSFileServer.mm` implements local-network file transfer.
- The file-transfer server listens on port 8080 and accepts game-data archives,
  supported ROM extensions, mods, and saves.
- `soh/soh/OTRGlobals.cpp` starts the transfer service during tvOS startup and
  presents transfer status when required game data is missing.
- `soh/soh/Enhancements/bootcommands.c` enables controller navigation on tvOS.
- `SohMenuSettings.cpp` exposes transfer status and start/stop controls.
- `libultraship/src/ship/Context.cpp` uses the Apple application-data location
  for configuration, saves, logs, and other persistent data.
- The tvOS plist declares the supported game-controller profiles.
- The Apple build selects the existing Metal-based graphics path and disables
  unsupported iOS sensor/CoreMotion functionality for tvOS.

## Storage risk identified

The current tvOS implementation does not yet satisfy the persistent-storage
requirement. `libultraship/src/ship/Context.cpp` returns
`~/Library/Caches/Ship of Harkinian` for the tvOS application directory, and
`soh/ios/SOHTVOSFileServer.mm` also uses `NSCachesDirectory` for uploaded
files. Apple documents `Library/Caches` as discardable and eligible for
purging when space is needed.

Therefore, the current implementation may lose `oot.o2r`, saves, and other
application data after tvOS storage reclamation. This must be corrected before
claiming persistent game-data or save support. The eventual fix should move
non-recreatable data to an appropriate persistent directory such as
Application Support, update all readers and writers consistently, and migrate
existing files from the legacy cache location when possible.

The Apple build requires a locally generated `soh.o2r`. The existing
`GenerateSohOtr` CMake target creates this ROM-free Ship support archive; it
does not require a Nintendo ROM. The final app bundle produced in this test
contained `soh.o2r`.

## Attempts and results

### Repository setup

Completed:

```sh
git clone --recursive https://github.com/linkzenic/Ship-of-Harkinian-iOS.git
git submodule update --init --recursive
git switch -c tvos-device-validation
```

No tracked source changes have been made during initial inspection.

### Host support archive

The documented CMake target was used to generate the local support archive:

```sh
cmake --build build-host --target GenerateSohOtr --config Release
```

The first tvOS configuration correctly refused to continue while
`soh/soh.o2r` was absent. After generation, the archive was available locally
and remains ignored by Git.

### Unchanged tvOS build

The documented command was attempted first:

```sh
DEVELOPMENT_TEAM=<TEAM_ID> scripts/build-ios.sh --tvos-device
```

Before source changes, this environment failed during CMake’s compiler test
because Xcode 27 no longer supports the fork’s default tvOS deployment target
14.0. The SDK supports deployment targets from 15.0 upward.

The same build then succeeded with a local environment override:

```sh
DEPLOYMENT_TARGET=15.0 scripts/build-ios.sh --tvos-device
```

Result:

```text
** BUILD SUCCEEDED **
tvOS device app: build-tvos-device/soh/Release-appletvos/Ship of Harkinian.app
```

The resulting executable is arm64. The app bundle contains the executable,
Metal/app assets, controller database, and generated `soh.o2r`.

### Signing and device availability

The initial command-line inspection reported no usable identities:

```text
0 valid identities found
```

No personal team identifier or bundle identifier has been committed. Xcode was
subsequently able to apply the developer’s local signing configuration and
deploy the app to the paired physical Apple TV.

The command-line device service was also checked:

```sh
xcrun devicectl list devices
```

CoreDevice timed out during the earlier command-line check, but Xcode’s
wireless deployment path was usable. The physical launch then exposed the
UIKit scene-lifecycle startup failure recorded below.

### Xcode destination mismatch

An attempt to run `build-tvos-device/Ship.xcodeproj` from Xcode with a tvOS
Simulator destination failed with:

```text
Building for 'tvOS-simulator', but linking in dylib .../AppleTVOS.sdk/usr/lib/libz.1.tbd built for 'tvOS'
```

Diagnosis: the device-generated project is being built for a simulator
destination. The project’s application scheme is `soh`, and it must be run
with the paired physical Apple TV selected. Simulator testing requires a
separate project generated with `--tvos-simulator`.

No source change was made for this failure.

### CloudKit signing configuration

The generated Apple target enables CloudKit by default and requests the shared
container `iCloud.com.shipofharkinian.shared`. A developer team that does not
own that container receives an Xcode signing error stating that the container
is unavailable.

For initial device bring-up, configure the build with
`SOH_ENABLE_ICLOUD=OFF`. The fork then generates its no-cloud entitlements and
sets the runtime build marker so local saves continue to work without trying
to use the unavailable container. CloudKit should be validated separately
with a container registered to the developer’s own team.

### UIKit scene lifecycle startup failure

The first signed physical launch on the current SDK reached UIKit but showed a
black screen and logged that a UIScene lifecycle is required. The generated app
uses SDL 2.32.10, whose UIKit backend starts through the legacy app delegate
and did not declare a tvOS scene configuration.

The narrow fix is an SDL2 UIKit scene-lifecycle patch applied through the
existing CMake dependency patch mechanism, plus the tvOS scene manifest. The
patch was compiled successfully for arm64 tvOS 15.0 with Xcode 27, and the
packaged app now contains `UIApplicationSceneManifest` with
`SDLUIKitSceneDelegate`. A signed redeploy and physical relaunch are still
required before evaluating SDL, Metal, audio, or game-data behavior.

## Current diagnosis

The existing tvOS implementation reaches a successful arm64 compile and link
after generating its expected ROM-free support archive. A signed build was
deployed to the physical Apple TV, where the first launch exposed the legacy
SDL UIKit lifecycle failure. The corrected validation build now compiles and
packages the scene manifest successfully. The next required step is a signed
rebuild/redeploy with the developer’s local signing settings, followed by
validation of startup, rendering, audio, storage, file transfer, extraction,
controller input, suspend/resume, and save behavior on hardware.

No speculative Apple-port rewrite has been made.

## Physical-device result

Initial signed deployment: app installed, but launch showed a black screen.
Xcode console reported that the UIScene lifecycle was required and identified
`SDL_UIKitRunApp` in the legacy SDL UIKit backend. Diagnosis was confirmed as
the SDL 2.32.10 app-delegate path lacking a tvOS scene configuration for the
current SDK.

Fix validation: arm64 tvOS 15.0 build succeeds, the app bundle contains the
scene manifest, and the SDL scene-lifecycle patch compiles. Physical-device
relaunch is pending.

## Test log

Use this format for each test:

```text
Date:
Attempt:
Observed:
Diagnosis:
Change made:
Physical-device result:
```

### 2026-09-27: UIKit scene lifecycle fix validation

```text
Attempt: Rebuild the existing tvOS device target after the black-screen launch.
Observed: The first rebuild exposed one SDL availability-macro spelling error.
Diagnosis: The scene configuration method must use tvos(13.0), not tvOS(13.0).
Change made: Corrected the SDL dependency patch and rebuilt the generated target.
Physical-device result: Build/package validation passed; signed redeploy pending.
```

### 2026-09-27: tvOS transfer-popup controller navigation

The physical device reached the transfer dialog after the ROM upload, but the
Rescan and Exit buttons could not be activated with the Siri Remote or a
Bluetooth controller. The upload server’s connection invalidation warning is
expected after the browser request closes; it is not the input failure.

The tvOS build enables ImGui controller navigation, but the generic GUI code
only enabled the navigation flag when the main menu or menubar was visible.
The transfer screen is a modal popup shown before that menu, so it rendered
without a navigable gamepad focus. `Gui::StartFrame()` now keeps navigation
enabled while a modal popup is open on tvOS. The rebuilt arm64 target passed.
Physical-device redeploy and activation of Rescan remain pending.

### 2026-09-27: transfer URL interface selection

The Apple TV displayed a `10.32.x.x` upload address while its reachable LAN
address was `192.168.50.81`. The original URL selection used the first active
non-loopback IPv4 interface, which could select a tunnel or other interface.
Because `10.0.0.0/8` is private address space, this was not an ISP public
address; it was most likely a tunnel/VPN interface.

`SOHTVOSFileServer.mm` now ignores tunnel, cellular, peer-to-peer, and link-
local interfaces and prefers physical `en0`/`en1` addresses, with private LAN
addresses preferred as a fallback. The arm64 tvOS target rebuilt successfully.

The subsequent physical test showed the corrected LAN address, but the Safari
upload remained at 100% with an `Uploading...` status and the transfer popup
was still not actionable. tvOS controller navigation is now kept enabled for
the entire tvOS frame whenever the platform setting is enabled, rather than
depending on menu visibility. Upload receive/install diagnostics were also
added to the Xcode console. The transfer server now logs the HTTP response
send and waits briefly after a successful send before closing the connection,
so Safari can complete its XMLHttpRequest. The target rebuilt successfully;
the latest signed device run is still pending.
