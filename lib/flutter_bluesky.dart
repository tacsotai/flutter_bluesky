import 'flutter_bluesky_platform_interface.dart';

class FlutterBluesky {
  Future<String?> getPlatformVersion() {
    return FlutterBlueskyPlatform.instance.getPlatformVersion();
  }
}
