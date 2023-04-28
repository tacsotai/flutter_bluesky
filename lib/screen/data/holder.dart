import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';

class HomeDataHolder extends FeedDataHolder {}

class ProfileDataHolder extends FeedDataHolder {
  late ProfileViewDetailed detail;

  void makeProfile(Map map) async {
    detail = ProfileViewDetailed(map);
  }
}

class FeedResponse {
  String cursor;
  List feed = [];
  final Map<String, Feed> map = {};

  FeedResponse(Map body)
      : cursor = body["cursor"],
        feed = body["feed"] {
    for (var element in feed) {
      Feed feed = Feed(element);
      map[feed.post.uri] = feed;
    }
  }
}

class FeedDataHolder {
  String? cursor;
  List<Feed> feeds = [];
  // Avoid for dupulication data
  final Map<String, Feed> feedMap = {};

  void makeFeeds(bool insert, FeedResponse res) {
    // initial load.
    if (cursor == null) {
      _appendFeeds(res.map);
    }
    // insert or append.
    else {
      if (insert) {
        _insertFeeds(res.map);
      } else {
        if (cursor != res.cursor) {
          _appendFeeds(res.map);
        } else {
          // cursor == resCursor case, Do nothing. Noting change.
        }
      }
    }
  }

  void _appendFeeds(Map<String, Feed> map) {
    feedMap.addAll(map);
    feeds.addAll(map.values);
  }

  // insert if the list element not in feeds.
  void _insertFeeds(Map<String, Feed> map) {
    List<Feed> inserts = [];
    for (MapEntry entry in map.entries) {
      if (feedMap[entry.key] == null) {
        inserts.add(entry.value);
      }
    }
    feeds.insertAll(0, inserts);
  }
}
