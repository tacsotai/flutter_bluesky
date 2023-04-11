import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bluesky/flutter_bluesky_method_channel.dart';

void main() {
  MethodChannelFlutterBluesky platform = MethodChannelFlutterBluesky();
  const MethodChannel channel = MethodChannel('flutter_bluesky');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
