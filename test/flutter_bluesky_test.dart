import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  // Make sure to run 'make run-dev-env'
  test('register', () async {
    Tuple2 res = await plugin.register("foo@bar.com", "hoge.test", "password");
    if (res.item1 == 200) {
      return;
    }
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

  // test('timeline cursor', () async {
  //   await plugin.login("foo@bar.com", "password");
  //   Tuple2 res = await plugin.timeline();
  //   expect(res.item1, 200);
  // });

  test('post', () async {
    String text = randomAlphaNumeric(10);
    await plugin.login("foo@bar.com", "password");
    await plugin.post(text);
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

  test('post picture', () async {
    await plugin.login("foo@bar.com", "password");
    String filename = '2718714879_b56c626a17.jpg';
    String url = 'https://farm4.static.flickr.com/3003/$filename';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    // Caution; ContentType is very important. Server can't know it.
    // This is client responsivility.
    Tuple2 res = await plugin.uploadBlob(bytes, "image/jpeg");
    expect(res.item2["blob"]["mimeType"], "image/jpeg");
    List<Map>? images = [];
    Map element = {"image": res.item2["blob"], "alt": ""};
    images.add(element);
    Tuple2 res2 = await plugin.post('post picture and text2', images: images);
    debugPrint("code: ${res2.item1}");
  });
}
