import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/bluesky.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:tuple/tuple.dart';

FlutterBluesky? _plugin;

FlutterBluesky get plugin {
  return _plugin!;
}

void setPlugin(FlutterBluesky plugin) {
  _plugin = plugin;
}

bool get hasSession {
  return _plugin != null;
}

// This is a service class for atproto pds.
class FlutterBluesky extends Bluesky {
  Map serverDescription = {};

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
      api.session.set(res.item2);
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

  // actor = null after login
  Future<void> _profile() async {
    Tuple2 res = await getProfile(api.session.did!);
    if (res.item1 == 200) {
      api.session.actor = ProfileViewDetailed(res.item2);
    }
  }

  // Future<List> followees() async {
  //   return [];
  // }

  // Future<List> followers() async {
  //   return [];
  // }

  Future<Tuple2> timeline({String? cursor}) async {
    return await getTimeline(30, "reverse-chronological", cursor: cursor);
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

  // "root": {
  //   "uri": "at://did:plc:djwdt5zwcdppta5akpdyenxu/app.bsky.feed.post/3jw4yi3ghlk2b",
  //   "cid": "bafyreie2lbgyjdtfoi4zeplzdgwkll3ze2fkk3332e2mdver32zoerjjau"
  // },
  // "parent": {
  //   "uri": "at://did:plc:djwdt5zwcdppta5akpdyenxu/app.bsky.feed.post/3jw4yi3ghlk2b",
  //   "cid": "bafyreie2lbgyjdtfoi4zeplzdgwkll3ze2fkk3332e2mdver32zoerjjau"
  // }
  Future<Tuple2> reply(String? text, Map root, Map parent,
      {List<Map>? images}) async {
    Map<String, dynamic>? record = {
      "reply": {"root": root, "parent": parent}
    };
    return await post(text, images: images, record: record);
  }

  // "embed": {
  //   "$type": "app.bsky.embed.record",
  //   "record": {
  //     "uri": "at://did:plc:djwdt5zwcdppta5akpdyenxu/app.bsky.feed.post/3jw4yi3ghlk2b",
  //     "cid": "bafyreie2lbgyjdtfoi4zeplzdgwkll3ze2fkk3332e2mdver32zoerjjau"
  //   }
  // }
  Future<Tuple2> quote(String? text, Map quote, {List<Map>? images}) async {
    Map<String, dynamic>? record = {
      "embed": {"\$type": "app.bsky.embed.record", "record": quote}
    };
    return await post(text, images: images, record: record);
  }

  Future<Tuple2> repost(String uri, String cid) async {
    return _likeRepost("app.bsky.feed.repost", uri, cid);
  }

  Future<Tuple2> like(String uri, String cid) async {
    return _likeRepost("app.bsky.feed.like", uri, cid);
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

  Future<Tuple2> unlike(String uri) async {
    return await _unlikeUndo("app.bsky.feed.like", uri);
  }

  Future<Tuple2> undo(String uri) async {
    return await _unlikeUndo("app.bsky.feed.repost", uri);
  }

  // 'at://did:plc:72i5sqnrlvphcxjllqzzslft/app.bsky.feed.repost/3jw2xxfd7fs24'
  Future<Tuple2> _unlikeUndo(String collection, String uri) async {
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
