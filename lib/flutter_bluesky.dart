import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/bluesky.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/graph.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/api/refresh_api.dart';
import 'package:flutter_bluesky/login.dart';
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

void checkSession(BuildContext context) {
  _plugin!.getSession().then((res) => loginExpire(res, context));
}

void loginExpire(Tuple2 res, BuildContext context) {
  if (res.item1 != 200) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

// This is a service class for atproto pds.
class FlutterBluesky extends Bluesky {
  Map serverDescription = {};

  // TODO multiple case.
  String get domain {
    return serverDescription["availableUserDomains"][0];
  }

  String get initActorsSearch {
    return domain;
  }

  FlutterBluesky({String? provider, String? key})
      : super(
            api: RefreshAPI(
                session: Session.create(provider: provider, key: key)));

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
      await sessionAPI.resessiion(res);
    }
    return res;
  }

  // id = email or handle
  Future<Tuple2> login(String emailORhandle, String password) async {
    // before login remove session from local storage in case session expired.
    api.session.remove();
    Tuple2 res = await createSession(emailORhandle, password);
    if (res.item1 == 200) {
      api.session.set(res.item2);
      await sessionAPI.profile();
    }
    return res;
  }

  Future<Tuple2> logout() async {
    api.session.remove();
    return await deleteSession();
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
    await sessionAPI.profile();
  }

  Future<List<ProfileView>> followings(String actor) async {
    List<ProfileView> followings = [];
    Tuple2 res = await getFollows(actor);
    FollowsResponse response = FollowsResponse(res.item2);
    for (Map follwer in response.follows) {
      followings.add(ProfileView(follwer));
    }
    return followings;
  }

  Future<List<ProfileView>> followers(String actor) async {
    List<ProfileView> followings = [];
    Tuple2 res = await getFollowers(actor);
    FollowersResponse response = FollowersResponse(res.item2);
    for (Map follwer in response.followers) {
      followings.add(ProfileView(follwer));
    }
    return followings;
  }

  Future<List<ProfileView>> blocks() async {
    List<ProfileView> blocks = [];
    Tuple2 res = await getBlocks();
    BlocksResponse response = BlocksResponse(res.item2);
    for (Map block in response.blocks) {
      blocks.add(ProfileView(block));
    }
    return blocks;
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
  Future<List<Map>?> upload(List<ImageFile> imgFiles) async {
    List<Map>? images = [];
    for (var imgFile in imgFiles) {
      Tuple2 res = await plugin.uploadBlob(imgFile.bytes, imgFile.mimeType!);
      images.add({"image": res.item2["blob"], "alt": ""});
    }
    if (images.isEmpty) {
      images = null;
    }
    return images;
  }

  Future<Tuple2> post(Map<String, dynamic> record) async {
    return await createRecord(api.session.did!, "app.bsky.feed.post", record);
  }

  Future<Tuple2> repost(String uri, String cid) async {
    return _likeRepost("app.bsky.feed.repost", uri, cid);
  }

  Future<Tuple2> like(String uri, String cid) async {
    return _likeRepost("app.bsky.feed.like", uri, cid);
  }

  Future<Tuple2> unlike(String uri) async {
    return await _unlink(uri);
  }

  Future<Tuple2> _likeRepost(String collection, String uri, String cid) async {
    return await createRecord(
      api.session.did!,
      collection,
      {
        "subject": {"uri": uri, "cid": cid},
        "createdAt": DateTime.now().toUtc().toIso8601String()
      },
    );
  }

  Future<Tuple2> follow(String subject) async {
    return await createRecord(
      api.session.did!,
      "app.bsky.graph.follow",
      {
        "subject": subject,
        "createdAt": DateTime.now().toUtc().toIso8601String()
      },
    );
  }

  Future<Tuple2> unfollow(String uri) async {
    return await _unlink(uri);
  }

  Future<Tuple2> block(String did) async {
    return await createRecord(
      api.session.did!,
      "app.bsky.graph.block",
      {"subject": did, "createdAt": DateTime.now().toUtc().toIso8601String()},
    );
  }

  Future<Tuple2> unblock(String uri) async {
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

  Future<Tuple2> actorsSearch(
      {String? term, int? limit, String? cursor}) async {
    if (term == null || term.isEmpty) {
      term = initActorsSearch;
    }
    return await searchActors(term: term, limit: limit, cursor: cursor);
  }

  Future<String> did(String atHandle) async {
    Tuple2 res = await getProfile(atHandle.replaceAll("@", ""));
    return res.item2["did"];
  }
}
