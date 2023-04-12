// app.bsky.actor.getProfile?actor=did:plc:u5xrfsqb6d2xrph6t4uwwe2h
// app.bsky.actor.getSuggestions?limit=30&0::did:plc:wvget5m2jitpl45cuiof6dd2
// app.bsky.feed.getAuthorFeed?actor=tac.test&limit=30&cursor=1680751438717::bafyreialrmplevoltjvapppyk5zfhp2lh3hyngiyw2t3pzzttx7krrxx24
// app.bsky.feed.getTimeline?algorithm=reverse-chronological&limit=30
// app.bsky.feed.getPostThread?uri=at://did:plc:wvget5m2jitpl45cuiof6dd2/app.bsky.feed.post/3jsodsbfs4c2b&depth=0
// app.bsky.graph.getFollows?actor=did:plc:u5xrfsqb6d2xrph6t4uwwe2h
// app.bsky.notification.getUnreadCount
// app.bsky.notification.listNotifications?limit=30

import 'package:flutter_bluesky/api/atproto.dart';
import 'package:tuple/tuple.dart';

abstract class Bluesky extends Atproto {
  Bluesky({required super.api});

  Future<Tuple2> getProfile(String actor) async {
    // TODO implement
    return Tuple2<int, Map>(0, {});
  }

  Future<Tuple2> getSuggestions(String limit, String actor) async {
    // TODO implement
    return Tuple2<int, List>(0, []);
  }

  Future<Tuple2> getAuthorFeed(
      String limit, String actor, String cursor) async {
    // TODO implement
    return Tuple2<int, List>(0, []);
  }

  Future<Tuple2> getTimeLine(String limit, String algorithm) async {
    // TODO implement
    return Tuple2<int, List>(0, []);
  }

  Future<Tuple2> getPostThread(String uri) async {
    // TODO implement
    return Tuple2<int, List>(0, []);
  }

  Future<Tuple2> getFollows(String actor) async {
    // TODO implement
    return Tuple2<int, List>(0, []);
  }

  Future<Tuple2> getUnreadCount() async {
    // TODO implement
    return Tuple2<int, int>(0, 0);
  }

  Future<Tuple2> listNotifications(String limit) async {
    // TODO implement
    return Tuple2<int, List>(0, []);
  }
}
