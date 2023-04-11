#include "include/flutter_bluesky/flutter_bluesky_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_bluesky_plugin.h"

void FlutterBlueskyPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_bluesky::FlutterBlueskyPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
