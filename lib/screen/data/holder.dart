import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';

class HomeDataHolder extends FeedDataHolder {}

class ProfileDataHolder extends FeedDataHolder {
  late String user;
  late ProfileViewDetailed detail;

  void makeProfile(Map map) async {
    detail = ProfileViewDetailed(map);
  }
}

class FeedDataHolder {
  String? cursor;
  List<Feed> feeds = [];
  // Avoid for dupulication data
  final Map<String, Feed> feedMap = {};

  void makeFeeds(bool insert, FeedResponse res) {
    List<Feed> list = retrived(res);
    // initial load.
    if (cursor == null) {
      feeds.addAll(list);
    }
    // insert or append.
    else {
      if (insert) {
        feeds.insertAll(0, list);
      } else {
        if (cursor != res.cursor) {
          feeds.addAll(list);
        } else {
          // cursor == resCursor case, Do nothing. Noting change.
        }
      }
    }
    // Finally, set the cursor for next load.
    cursor = res.cursor;
  }

  // Add all data to map, then the list is only delta.
  List<Feed> retrived(FeedResponse res) {
    List<Feed> list = [];
    for (var element in res.feed) {
      Feed feed = Feed(element);
      if (feedMap[feed.post.uri] == null) {
        feedMap[feed.post.uri] = feed;
        list.add(feed);
      }
    }
    return list;
  }
}

// ProfileViewDetailed List
// app.bsky.actor.searchActors
// app.bsky.actor.getSuggestions
class SearchDataHolder {
  String? cursor;
  List<ProfileView> actors = [];

  void make(ProfileViews res) async {
    actors = res.actors;
    cursor = res.cursor;
  }
}
