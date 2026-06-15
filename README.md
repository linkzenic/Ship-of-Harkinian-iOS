# Ship of Harkinian Android

Android port of Ship of Harkinian, based on the HarbourMasters project.

Original repository: https://github.com/HarbourMasters/Shipwright

Current Android release: **v9.2.3-android.5**

Supported: Android 7+ with OpenGL ES 3.0+

Tested on: Android 15

Official website: https://www.shipofharkinian.com/

Official Discord: https://discord.com/invite/shipofharkinian

## Installation

1. Verify that you have a supported, legally obtained Ocarina of Time ROM. You can use the compatibility checker at https://ship.equipment/ or compare your ROM's `sha1` hash against [docs/supportedHashes.json](docs/supportedHashes.json).
2. Install the APK from the releases page: https://github.com/linkzenic/Shipwright-Android/releases
3. Open the app once so it can create the data folder and copy bundled support files.
4. When prompted, allow setup and select your ROM so the app can generate the required `.otr` or `.o2r` game data.
5. If you have a Master Quest ROM, choose to extract another ROM when prompted. Otherwise, continue into the game.
6. Subsequent launches should start directly into the game.

Use the Back, Select, or minus controller button, or the Android back gesture/button, to open the Ship of Harkinian menu. Use touch controls or a controller to navigate menus.

## Data Folder

The app stores user data in the selected `SOH` data folder. You can view the current folder and change it from Settings > General.

Mods and user files should be placed in the relevant folders inside the selected data folder. Mods use `.otr` or `.o2r` files and can be enabled from Settings > Mod Menu.

## FAQ

**Why is it immediately crashing?**

Try deleting and regenerating your extracted `.otr` or `.o2r` game data from your own ROM.

**The game opened once but now shows a black screen.**

Try deleting `imgui.ini` from your `SOH` folder. If it still happens, set MSAA to 1 in Settings > Graphics.

**My controller is not doing anything.**

Open the menu and check Settings > Controls to confirm the controller is detected and mapped. If this happens immediately after first setup, close and reopen the app once.

**Can I hide the on-screen touch controls?**

Yes. Use Settings > General > Disable Touch Controls.

**Can I resize the menu?**

Yes. Use Settings > General > Menu Scale.

**How do I add mods?**

Place mod `.otr` or `.o2r` files in the `mods` folder inside your selected `SOH` data folder, then enable them from Settings > Mod Menu.

## Known Issues

External Bluetooth controller rumble is not currently supported. Device vibration is used as a fallback on supported handhelds.

Touch overlay and physical controller button mappings share the same slot per port, so you cannot assign different actions to the same button on each.

Some pre-rendered backgrounds are limited by upstream Ship of Harkinian behavior and may not fill widescreen viewports.

## Build Notes

Android builds are produced through GitHub Actions. The APK bundles `soh.o2r` support data, but does not bundle extracted game data; users generate the required `.otr` or `.o2r` files from their own ROM.

Building locally requires Docker or another OCI-compatible container tool on Linux. Windows users should use WSL2 and clone the repository to a native Linux path rather than a Windows-mounted path.

```bash
git clone https://github.com/linkzenic/Shipwright-Android.git
cd Shipwright-Android
git submodule update --init --recursive
cd docker
make setup
make build_release
```

The resulting APK will be at `Android/app/build/outputs/apk/release/`.
