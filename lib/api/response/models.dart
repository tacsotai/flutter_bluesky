import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';

class ActorFeed {
  ProfileViewDetailed profile;
  CursorFeed autherFeed;

  ActorFeed(this.profile, Map map) : autherFeed = CursorFeed(map);
}

class CursorFeed {
  String cursor;
  List feed = [];
  final Map<String, Feed> feedMap = {};

  CursorFeed(Map map)
      : cursor = map["cursor"],
        feed = map["feed"] {
    for (var element in feed) {
      Feed feed = Feed(element);
      feedMap[feed.post.uri] = feed;
    }
  }
}
