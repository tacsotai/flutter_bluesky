import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/bluesky.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/graph.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/util/image_util.dart';
import 'package:tuple/tuple.dart';

FlutterBluesky? _plugin;

FlutterBluesky get plugin {
  return _plugin!;
}

void setPlugin(FlutterBluesky plugin) {
  _plugin = plugin;
}

bool get hasSession {
  return isAlive && _plugin!.api.session.accessJwt != null;
}

bool get isAlive {
  return _plugin != null;
}

// This is a service class for atproto pds.
class FlutterBluesky extends Bluesky {
  Map serverDescription = {};

  // TODO multiple case.
  String get domain {
    return serverDescription["availableUserDomains"][0];
  }

  FlutterBluesky({
    String? provider,
  }) : super(api: API(session: Session.create(provider: provider)));

  String getProvider() {
    return api.session.provider;
  }

  Future<Tuple2> connect() async {
    Tuple2 res = const Tuple2(
        400, {"error": "InvalidProvider", "message": "Check the url."});
    try {
      res = await describeServer();
      serverDescription = res.item2;
    } on Exception catch (e) {
      // TODO use logger.
      // ignore: avoid_print
      print(e.toString());
    }
    return res;
  }

  bool inviteCodeRequired() {
    return serverDescription["inviteCodeRequired"];
  }

  bool availableUserDomain(String handle) {
    for (var domain in serverDescription["availableUserDomains"]) {
      if (handle.endsWith(domain)) {
        return true;
      }
    }
    return false;
  }

  // Invoke after availableUserDomain, otherwise this API retuen error.
  Future<Tuple2> register(String email, String handle, String password,
      {String? inviteCode}) async {
    Tuple2 res =
        await createAccount(email, handle, password, inviteCode: inviteCode);
    if (res.item1 == 200 || res.item1 == 201) {
      _session(res);
    }
    return res;
  }

  // id = email or handle
  Future<Tuple2> login(String emailORhandle, String password) async {
    Tuple2 res = await createSession(emailORhandle, password);
    if (res.item1 == 200) {
      api.session.set(res.item2);
      await _profile();
    }
    return res;
  }

  Future<Tuple2> logout() async {
    return await deleteSession();
  }

  Future<Tuple2> refresh() async {
    Tuple2 res = await refreshSession();
    if (res.item1 == 200) {
      _session(res);
      await _profile();
    }
    return res;
  }

  Future<void> _session(Tuple2 res) async {
    api.session.accessJwt = res.item2["accessJwt"];
    Tuple2 res2 = await getSession();
    res.item2["email"] = res2.item2["email"];
    api.session.set(res.item2);
  }

  // actor = null after login
  Future<void> _profile() async {
    Tuple2 res = await getProfile(api.session.did!);
    if (res.item1 == 200) {
      api.session.actor = ProfileViewDetailed(res.item2);
    }
  }

  Future<void> updateProfile(
      {String? displayName,
      String? description,
      Map? avatar,
      Map? banner}) async {
    Map<String, dynamic> record = {};
    API.add(record, {
      "\$type": "app.bsky.actor.profile",
      "displayName": displayName,
      "description": description,
      "avatar": avatar,
      "banner": banner,
    });
    await putRecord(api.session.did!, "app.bsky.actor.profile", "self", record);
    await _profile();
  }

  Future<List<ProfileViewBasic>> followers(String actor) async {
    List<ProfileViewBasic> follwers = [];
    Tuple2 res = await plugin.getFollows(actor);
    FollowResponse response = FollowResponse(res.item2);
    for (Map follwer in response.follows) {
      follwers.add(ProfileViewBasic(follwer));
    }
    return follwers;
  }

  Future<Tuple2> timeline({String? cursor}) async {
    return await getTimeline(cursor: cursor);
  }

  // blobs: a list the results of several times uploadBlob
  // {
  //   "blob": {
  //     "$type": "blob",
  //     "ref": {
  //       "$link": "bafkreiar57k65z2w3tg2opx3gfqwoncxjr7gll4ptvywtw5tmohbhks7ly"
  //     },
  //     "mimeType": "image/jpeg",
  //     "size": 50140
  //   }
  // }
  // Then set the return value to record as embed like this.
  // {
  //   "repo": "did:plc:djwdt5zwcdppta5akpdyenxu",
  //   "collection": "app.bsky.feed.post",
  //   "record": {
  //     "text": "pepe",
  //     "createdAt": "2023-04-05T08:16:04.692Z",
  //     "embed": {
  //       "$type": "app.bsky.embed.images",
  //       "images": [
  //         {
  //           "image": {
  //             "$type": "blob",
  //             "ref": {
  //               "$link": "bafkreiar57k65z2w3tg2opx3gfqwoncxjr7gll4ptvywtw5tmohbhks7ly"
  //             },
  //             "mimeType": "image/jpeg",
  //             "size": 50140
  //           },
  //           "alt": ""
  //         }
  //       ]
  //     }
  //   }
  // }
  Future<void> upload(String text, Map<String, dynamic>? record,
      List<ImageFile> imgFiles) async {
    List<Map>? images = [];
    for (var imgFile in imgFiles) {
      Tuple2 res = await plugin.uploadBlob(imgFile.bytes, imgFile.mimeType!);
      images.add({"image": res.item2["blob"], "alt": ""});
    }
    if (images.isEmpty) {
      images = null;
    }
    await post(text, images: images, record: record);
  }

  Future<Tuple2> post(String? text,
      {List<Map>? images, Map<String, dynamic>? record}) async {
    if (text == null && images == null) {
      throw Exception("Did you want to say anything?"); // TODO
    }
    record ??= {};
    if (images != null) {
      record["embed"] = {"\$type": "app.bsky.embed.images", "images": images};
    }
    return await _post(text, record);
  }

  Future<Tuple2> _post(String? text, Map<String, dynamic> record) async {
    record["text"] = text;
    record["createdAt"] = DateTime.now().toIso8601String();
    return await createRecord(api.session.did!, "app.bsky.feed.post", record);
  }

  Future<Tuple2> repost(String uri, String cid) async {
    return _likeRepost("app.bsky.feed.repost", uri, cid);
  }

  Future<Tuple2> like(String uri, String cid) async {
    return _likeRepost("app.bsky.feed.like", uri, cid);
  }

  Future<Tuple2> follow(String subject) async {
    return await createRecord(
      api.session.did!,
      "app.bsky.graph.follow",
      {"subject": subject, "createdAt": DateTime.now().toIso8601String()},
    );
  }

  Future<Tuple2> _likeRepost(String collection, String uri, String cid) async {
    return await createRecord(
      api.session.did!,
      collection,
      {
        "subject": {"uri": uri, "cid": cid},
        "createdAt": DateTime.now().toIso8601String()
      },
    );
  }

  Future<Tuple2> unfollow(String uri) async {
    return await _unlink(uri);
  }

  Future<Tuple2> unlike(String uri) async {
    return await _unlink(uri);
  }

  Future<Tuple2> undo(String uri) async {
    return await _unlink(uri);
  }

  // 'at://did:plc:72i5sqnrlvphcxjllqzzslft/app.bsky.feed.repost/3jw2xxfd7fs24'
  Future<Tuple2> _unlink(String uri) async {
    List<String> splits = uri.split("/");
    return await deleteRecord(splits[2], splits[3], splits[4]);
  }

  // Future<int> noticeCount() async {
  //   return 0;
  // }

  // Future<List> notifications() async {
  //   return [];
  // }
}
