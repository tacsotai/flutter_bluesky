import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/flutter_bluesky_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBlueskyPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBlueskyPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterBlueskyPlatform initialPlatform =
      FlutterBlueskyPlatform.instance;

  });

  test('connect', () async {
    FlutterBluesky flutterBlueskyPlugin = FlutterBluesky();
    expect(await flutterBlueskyPlugin.connect(), true);
  });
}
