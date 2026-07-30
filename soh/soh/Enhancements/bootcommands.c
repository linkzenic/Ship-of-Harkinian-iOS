#include <stddef.h>
#include <stdbool.h>
#include <libultraship/bridge.h>
#include "bootcommands.h"
#include "soh/cvar_prefixes.h"

#if defined(__IOS__) && !defined(__TVOS__)
#include "ios/SOHiOSTouchControls.h"
#endif
#ifdef __TVOS__
#include "ios/SOHTVOSFileServer.h"
#endif

void BootCommands_Init() {
    // Clears vars to prevent randomizer menu from being disabled
    CVarClear(CVAR_GENERAL("RandoGenerating")); // Clear when a crash happened during rando seed generation
    CVarClear(CVAR_GENERAL("NewSeedGenerated"));
    CVarClear(CVAR_GENERAL("OnFileSelectNameEntry")); // Clear when soh is killed on the file name entry page
    CVarClear(CVAR_GENERAL("BetterDebugWarpScreenMQMode"));
    CVarClear(CVAR_GENERAL("BetterDebugWarpScreenMQModeScene"));
#if defined(__SWITCH__) || defined(__WIIU__) || defined(__ANDROID__)
    CVarRegisterInteger(CVAR_IMGUI_CONTROLLER_NAV, 1); // always enable controller nav on switch/wii u/android
#elif defined(__TVOS__)
    CVarSetInteger(CVAR_IMGUI_CONTROLLER_NAV, 1);
    SOHTVOSFileServer_Start();
#elif defined(__IOS__)
    CVarSetInteger(CVAR_IMGUI_CONTROLLER_NAV, 1);
    CVarRegisterInteger(CVAR_SETTING("TouchControls.Disabled"), 0);
    CVarRegisterInteger(CVAR_SETTING("TouchControls.FaceButtonLayout"), 0);
    SOHiOS_SetTouchControlsEnabled(
        !CVarGetInteger(CVAR_SETTING("TouchControls.Disabled"), 0));
    SOHiOS_SetFaceButtonLayout(
        CVarGetInteger(CVAR_SETTING("TouchControls.FaceButtonLayout"), 0));
#endif
}
