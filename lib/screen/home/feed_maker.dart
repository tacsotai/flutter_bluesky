import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:tuple/tuple.dart';

class FeedMaker {
  String? cursor;
  // map[feed.post.uri] = feed;
  final Map<String, Feed> feedMap = {};
  List<Feed> feeds = [];

  Future<void> getFeeds(bool insert) async {
    Tuple2 res = await plugin.timeline(cursor: insert ? null : cursor);
    String resCursor = res.item2["cursor"];
    Map<String, Feed> map = _getMap(res.item2["feed"]);
    makeFeeds(insert, resCursor, map);
    cursor = resCursor;
  }

  void makeFeeds(bool insert, String resCursor, Map<String, Feed> map) {
    debugPrint("insert: $insert, resCursor: $resCursor");
    // initial load.
    if (cursor == null) {
      _appendFeeds(map);
    }
    // insert or append.
    else {
      if (insert) {
        _insertFeeds(map);
      } else {
        if (cursor != resCursor) {
          _appendFeeds(map);
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
    debugPrint("feedMap: $feedMap");
    debugPrint("map: $map");
    List<Feed> inserts = [];
    for (MapEntry entry in map.entries) {
      if (feedMap[entry.key] == null) {
        debugPrint("entry.key: ${entry.key}");
        inserts.add(entry.value);
      }
    }
    feeds.insertAll(0, inserts);
  }

  Map<String, Feed> _getMap(List feeds) {
    Map<String, Feed> map = {};
    for (var element in feeds) {
      Feed feed = Feed(element);
      map[feed.post.uri] = feed;
    }
    return map;
  }
}
