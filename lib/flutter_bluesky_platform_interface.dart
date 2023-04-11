import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_bluesky_method_channel.dart';

abstract class FlutterBlueskyPlatform extends PlatformInterface {
  /// Constructs a FlutterBlueskyPlatform.
  FlutterBlueskyPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBlueskyPlatform _instance = MethodChannelFlutterBluesky();

  /// The default instance of [FlutterBlueskyPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBluesky].
  static FlutterBlueskyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBlueskyPlatform] when
  /// they register themselves.
  static set instance(FlutterBlueskyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
