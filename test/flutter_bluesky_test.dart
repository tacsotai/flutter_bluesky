import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/graph.dart';
import 'package:flutter_bluesky/api/model/record.dart';
import 'package:flutter_bluesky/data/config.dart';
import 'package:flutter_bluesky/util/post_util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:tuple/tuple.dart';
import 'package:random_string/random_string.dart';
import 'package:mockito/mockito.dart';

// Integrated test code for FlutterBluesky.
// Run local server with https://zenn.dev/tac519/articles/727fca3783010c

// Mock Context
// https://stackoverflow.com/questions/56277477/unit-testing-in-flutter-passing-buildcontext

// XXX CHANGE consts with YOUR ENVIRONMENT.
const testProvider = "http://localhost:2583";
const email = "foo@bar.com";
const handle = "hoge.test";
const password = "password";
const Map serverDescription = {
  "availableUserDomains": [".test,.dev.bsky.dev"],
  "inviteCodeRequired": false,
  "links": {}
};

Map<String, dynamic> testRecord = {
  "tags": ["abc"],
  "labels": {
    "\$type": "com.atproto.label.defs#selfLabels",
    "values": [
      {
        "val": "profileView",
        "type": {
          "did": "did:plc:ugqaiaq4fw5uzyo75f3icmrx",
          "handle": "hoge.test",
          "displayName": "Foo",
          "description": "Bar",
          "followsCount": 0,
          "followersCount": 0,
          "postsCount": 1,
          "indexedAt": "2023-11-04T02:25:35.528Z",
          "viewer": {
            "muted": false,
            "blockedBy": false,
            "blocking":
                "at://did:plc:d3tdnbwjkoq6rpaa2vli2adi/app.bsky.graph.block/3kdshvaey2k2l"
          },
          "labels": []
        }
      }
    ]
  }
};

void main() {
  config = Config({"timeout": 5000, "sleep": 500});
  FlutterBluesky plugin = FlutterBluesky(testProvider, "testKey");

  Future<Tuple2> login(String emailORhandle, String password) async {
    Tuple2 res = await plugin.createSession(email, password);
    if (res.item1 == 200) {
      plugin.api.session.setTokens(res.item2["did"], res.item2["handle"],
          res.item2["email"], res.item2["accessJwt"], res.item2["refreshJwt"]);
      await plugin.sessionAPI.profile();
      setPlugin(plugin);
    }

    return res;
  }

  Future<Tuple2> register(String email, String handle, String password) async {
    Tuple2 res = await plugin.createAccount(email, handle, password);
    if (res.item1 == 200 || res.item1 == 201) {
      plugin.api.session.accessJwt = res.item2["accessJwt"];
      Tuple2 res2 = await plugin.getSession();
      res.item2["email"] = res2.item2["email"];
      plugin.api.session.setTokens(res.item2["did"], res.item2["handle"],
          res.item2["email"], res.item2["accessJwt"], res.item2["refreshJwt"]);
      await plugin.sessionAPI.profile();
    }
    return res;
  }

  test('connect to bsky.social', () async {
    FlutterBluesky defaultPlugin = FlutterBluesky(testProvider, "testKey");
    Tuple2 res = await defaultPlugin.connect();
    expect(res.item1, 200);
    Map expected = {
      "availableUserDomains": [".bsky.social"],
      "inviteCodeRequired": true,
      "links": {
        "privacyPolicy": "https://blueskyweb.xyz/support/privacy-policy",
        "termsOfService": "https://blueskyweb.xyz/support/tos"
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
    expect(res.item2, serverDescription);
  });

  // Make sure to run 'make run-dev-env'
  test('register', () async {
    Tuple2 res = await register(email, handle, password);
    if (res.item1 == 200) {
      return;
    }
    if (!(res.item1 == 400 &&
        res.item2["message"] == "Handle already taken: $handle")) {
      Tuple2 res2 = await register(email, handle, password);
      expect(res2.item1, 200);
    }
  });

  test('register NG, handle domain is not available', () async {
    Tuple2 res = await register(email, handle, password);
    expect(res.item1, 400);
  });

  test('login OK', () async {
    Tuple2 res = await login(email, password);
    expect(res.item1, 200);
  });

  test('login failure', () async {
    Tuple2 res = await login(email, "hoge");
    expect(res.item1, 401);
  });

  test('timeline', () async {
    await login(email, password);
    Tuple2 res = await plugin.timeline();
    expect(res.item1, 200);
  });

  test('followings', () async {
    await login(email, password);
    FollowsResponse res = await plugin.followings(handle);
    List<ProfileView> list = res.graph.actors;
    // ignore: prefer_is_empty
    expect(list.length >= 0, true);
  });

  test('followers', () async {
    await login(email, password);
    FollowersResponse res = await plugin.followers(handle);
    List<ProfileView> list = res.graph.actors;
    // ignore: prefer_is_empty
    expect(list.length >= 0, true);
  });

  test('blocks', () async {
    await login(email, password);
    BlocksResponse res = await plugin.blocks();
    List<ProfileView> list = res.graph.actors;
    // ignore: prefer_is_empty
    expect(list.length >= 0, true);
  });

  test('post', () async {
    String text = randomAlphaNumeric(10);
    await plugin.connect();
    await login(email, password);
    await PostUtil.post(text, MockBuildContext(), files: []);
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
    await login(email, password);
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
    Map<String, dynamic> record = {};
    record["text"] = 'post picture and text2';
    record["embed"] = {"\$type": "app.bsky.embed.images", "images": images};
    Tuple2 res2 = await plugin.post(record);
    debugPrint("code: ${res2.item1}");
  });

  test('profile picture', () async {
    await login(email, password);
    String filename = '2718714879_b56c626a17.jpg';
    String url = 'https://farm4.static.flickr.com/3003/$filename';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    // Caution; ContentType is very important. Server can't know it.
    // This is client responsivility.
    Tuple2 res = await plugin.uploadBlob(bytes, "image/jpeg");
    expect(res.item2["blob"]["mimeType"], "image/jpeg");
    await plugin.updateProfile(
        displayName: "test displayName",
        description: "test description",
        avatar: res.item2["blob"]);
  });

  test('post labels and tags', () async {
    String text = randomAlphaNumeric(10);
    await plugin.connect();
    await login(email, password);
    await PostUtil.post(text, MockBuildContext(),
        files: [], record: testRecord);
    Tuple2 res2 = await plugin.timeline();
    List feeds = res2.item2["feed"];
    bool exist = false;
    for (Map map in feeds) {
      Feed feed = Feed(map);
      Record record = feed.post.record;
      if (text == record.text &&
          record.labels!.values[0].val == "profileView") {
        exist = true;
      }
    }
    expect(exist, true);
  });
}

class MockBuildContext extends Mock implements BuildContext {}
