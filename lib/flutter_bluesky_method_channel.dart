import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_bluesky_platform_interface.dart';

/// An implementation of [FlutterBlueskyPlatform] that uses method channels.
class MethodChannelFlutterBluesky extends FlutterBlueskyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bluesky');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
