import 'package:flutter_bluesky/db.dart';
import 'package:flutter_bluesky/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:isar/isar.dart';
import 'package:tuple/tuple.dart';

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
    Tuple2 res = await flutterBlueskyPlugin.connect();
    expect(res.item1, 200);
    Map expected = {
      "availableUserDomains": [".bsky.social"],
      "inviteCodeRequired": true,
      "links": {
        "privacyPolicy": "https://bsky.app/support/privacy",
        "termsOfService": "https://bsky.app/support/tos"
      }
    };
    expect(res.item2, expected);
    expect(flutterBlueskyPlugin.inviteCodeRequired(), true);
    expect(flutterBlueskyPlugin.availableUserDomain("hoge.bsky.social"), true);
    expect(flutterBlueskyPlugin.availableUserDomain("hoge.test"), false);
  });

  test('login email', () async {
    FlutterBluesky flutterBlueskyPlugin =
        FlutterBluesky(provider: "http://localhost:2583");
    try {
      Tuple2 res = await flutterBlueskyPlugin.login("foo@bar.com", "hoge");
      expect(res.item1, 200);
    } on APIPostException catch (e) {
      fail(e.message);
    }
  });
}
