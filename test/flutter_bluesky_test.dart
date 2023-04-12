import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/flutter_bluesky_platform_interface.dart';
import 'package:flutter_bluesky/flutter_bluesky_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const protocol = "https";
const domain = "sotai.co/snst";
const xrpc = "$protocol://$domain/xrpc/";

class MockFlutterBlueskyPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBlueskyPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterBlueskyPlatform initialPlatform =
      FlutterBlueskyPlatform.instance;

  test('$MethodChannelFlutterBluesky is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBluesky>());
  });

  test('getPlatformVersion', () async {
    FlutterBluesky flutterBlueskyPlugin = FlutterBluesky();
    MockFlutterBlueskyPlatform fakePlatform = MockFlutterBlueskyPlatform();
    FlutterBlueskyPlatform.instance = fakePlatform;

    expect(await flutterBlueskyPlugin.getPlatformVersion(), '42');
  });

  test('connect', () async {
    FlutterBluesky flutterBlueskyPlugin = FlutterBluesky();
    expect(await flutterBlueskyPlugin.connect(), true);
  });
}
