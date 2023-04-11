#ifndef FLUTTER_PLUGIN_FLUTTER_BLUESKY_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_BLUESKY_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_bluesky {

class FlutterBlueskyPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterBlueskyPlugin();

  virtual ~FlutterBlueskyPlugin();

  // Disallow copy and assign.
  FlutterBlueskyPlugin(const FlutterBlueskyPlugin&) = delete;
  FlutterBlueskyPlugin& operator=(const FlutterBlueskyPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_bluesky

#endif  // FLUTTER_PLUGIN_FLUTTER_BLUESKY_PLUGIN_H_
