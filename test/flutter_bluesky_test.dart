import 'package:flutter_bluesky/db.dart';
import 'package:flutter_bluesky/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/flutter_bluesky_platform_interface.dart';
import 'package:isar/isar.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBlueskyPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBlueskyPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  setUp(() async {
    await Isar.initializeIsarCore(
      download: true,
    );
    db.open();
  });

  tearDown(() async {
    db.close();
  });

  test('connect', () async {
    FlutterBluesky flutterBlueskyPlugin = FlutterBluesky();
    expect(await flutterBlueskyPlugin.connect(), 200);
  });

  test('login email', () async {
    FlutterBluesky flutterBlueskyPlugin =
        FlutterBluesky(provider: "http://localhost:2583");
    try {
      int status = await flutterBlueskyPlugin.login("foo@bar.com", "hoge");
      expect(status, 200);
    } on APIPostException catch (e) {
      fail(e.message);
    }
  });
}
