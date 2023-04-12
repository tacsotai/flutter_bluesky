// app.bsky.actor.getProfile?actor=did:plc:u5xrfsqb6d2xrph6t4uwwe2h
// app.bsky.actor.getSuggestions?limit=30&0::did:plc:wvget5m2jitpl45cuiof6dd2
// app.bsky.feed.getAuthorFeed?actor=tac.test&limit=30&cursor=1680751438717::bafyreialrmplevoltjvapppyk5zfhp2lh3hyngiyw2t3pzzttx7krrxx24
// app.bsky.feed.getTimeline?algorithm=reverse-chronological&limit=30
// app.bsky.feed.getPostThread?uri=at://did:plc:wvget5m2jitpl45cuiof6dd2/app.bsky.feed.post/3jsodsbfs4c2b&depth=0
// app.bsky.graph.getFollows?actor=did:plc:u5xrfsqb6d2xrph6t4uwwe2h
// app.bsky.notification.getUnreadCount
// app.bsky.notification.listNotifications?limit=30

import 'package:flutter_bluesky/api/atproto.dart';
import 'package:flutter_bluesky/data/model/actor.dart';
import 'package:flutter_bluesky/data/model/notification.dart';
import 'package:flutter_bluesky/data/model/post.dart';
import 'package:flutter_bluesky/data/model/profile.dart';
import 'package:flutter_bluesky/data/model/viewer.dart';

abstract class Bluesky extends Atproto {
  Bluesky({required super.api});

  Future<Profile> getProfile(String actor) async {
    return Profile(
        handle: "handle",
        did: actor,
        followsCount: 0,
        followersCount: 0,
        postsCount: 0,
        viewer: Viewer(muted: false));
  }

  Future<List<Actor>> getSuggestions(String limit, String actor) async {
    return [];
  }

  Future<List<Post>> getAuthorFeed(
      String limit, String actor, String cursor) async {
    return [];
  }

  Future<List<Post>> getTimeLine(String limit, String algorithm) async {
    return [];
  }

  Future<List<Post>> getPostThread(String uri) async {
    return [];
  }

  Future<List<Actor>> getFollows(String actor) async {
    return [];
  }

  Future<int> getUnreadCount() async {
    return 0;
  }

  Future<List<Notification>> listNotifications(String limit) async {
    return [];
  }
}
