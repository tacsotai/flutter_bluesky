import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:tuple/tuple.dart';
import 'package:random_string/random_string.dart';

// Integrated test code for FlutterBluesky.
// Run local server with https://zenn.dev/tac519/articles/727fca3783010c
void main() {
  FlutterBluesky plugin = FlutterBluesky(provider: "http://localhost:2583");

  test('connect to bsky.social', () async {
    FlutterBluesky defaultPlugin = FlutterBluesky();
    Tuple2 res = await defaultPlugin.connect();
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
    expect(defaultPlugin.inviteCodeRequired(), true);
    expect(defaultPlugin.availableUserDomain("hoge.bsky.social"), true);
    expect(defaultPlugin.availableUserDomain("hoge.test"), false);
  });

  test('connect', () async {
    Tuple2 res = await plugin.connect();
    expect(res.item1, 200);
    Map expected = {
      "availableUserDomains": [".test", ".dev.bsky.dev"],
      "inviteCodeRequired": false,
      "links": {}
    };
    expect(res.item2, expected);
  });

  test('register', () async {
    Tuple2 res = await plugin.register("foo@bar.com", "hoge.test", "password");
    if (!(res.item1 == 400 &&
        res.item2["message"] == "Handle already taken: hoge.test")) {
      Tuple2 res2 =
          await plugin.register("foo@bar.com", "hoge.test", "password");
      expect(res2.item1, 200);
    }
  });

  test('register NG, handle domain is not available', () async {
    Tuple2 res = await plugin.register("foo@bar.com", "handle", "password");
    expect(res.item1, 400);
  });

  test('login OK', () async {
    Tuple2 res = await plugin.login("foo@bar.com", "password");
    expect(res.item1, 200);
  });

  test('login failure', () async {
    Tuple2 res = await plugin.login("foo@bar.com", "hoge");
    expect(res.item1, 401);
  });

  test('timeline', () async {
    await plugin.login("foo@bar.com", "password");
    Tuple2 res = await plugin.timeline();
    expect(res.item1, 200);
  });

  test('post', () async {
    String text = randomAlphaNumeric(10);
    Tuple2 res = await plugin.login("foo@bar.com", "password");
    await plugin.post(res.item2["did"], text);
    Tuple2 res2 = await plugin.timeline();
    List feeds = res2.item2["feed"];
    bool exist = false;
    for (Map map in feeds) {
      Feed feed = Feed(map);
      String result = feed.post.record.text;
      if (text == result) {
        exist = true;
      }
    }
    expect(exist, true);
  });
}
