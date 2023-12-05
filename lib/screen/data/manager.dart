import 'package:flutter/cupertino.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/api/model/graph.dart';
import 'package:flutter_bluesky/api/model/notification.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/data/holder.dart';
import 'package:tuple/tuple.dart';

abstract class DataManager {
  // insert
  // true: load latest data for showing data below app bar
  // false: load old data for showing data above bottom bar
  Future<void> getData(bool insert, {String? term});
  int get length;
}

abstract class FeedDataManager extends DataManager {
  FeedDataHolder get feedHolder;

  @override
  int get length {
    return feedHolder.feeds.length;
  }
}

class HomeDataManager extends FeedDataManager {
  final HomeDataHolder holder = HomeDataHolder();
  @override
  FeedDataHolder get feedHolder => holder;

  @override
  Future<void> getData(bool insert, {String? term}) async {
    try {
      // debugPrint("holder.cursor: ${holder.cursor}");
      String? cursor = insert ? null : holder.cursor;
      // debugPrint("cursor: $cursor");
      // debugPrint("insert: $insert");
      Tuple2 res = await plugin.timeline(cursor: insert ? null : cursor);
      holder.makeFeeds(insert, FeedResponse(res.item2));
    } catch (e, stacktrace) {
      // TODO
      debugPrint("Error: $e");
      debugPrint("stacktrace: $stacktrace");
    }
  }
}

class ProfileDataManager extends FeedDataManager {
  final ProfileDataHolder holder = ProfileDataHolder();
  @override
  FeedDataHolder get feedHolder => holder;

  @override
  Future<void> getData(bool insert, {String? term}) async {
    try {
      await makeProfile();
      await makeFeed(insert);
    } catch (e) {
      debugPrint(e.toString()); // TODO
    }
  }

  Future<void> makeProfile() async {
    Tuple2 res = await plugin.getProfile(holder.actor);
    holder.makeProfile(res.item2);
  }

  Future<void> makeFeed(bool insert) async {
    String? cursor = insert ? null : holder.cursor;
    Tuple2 res =
        await plugin.getAuthorFeed(holder.actor, limit: 30, cursor: cursor);
    holder.makeFeeds(insert, FeedResponse(res.item2));
  }
}

class SearchDataManager extends DataManager {
  final SearchDataHolder holder = SearchDataHolder();

  // insert :excludeSelf(login user)
  @override
  Future<void> getData(bool insert, {String? term}) async {
    try {
      // String? cursor = holder.cursor; // TODO cursor
      Tuple2 res = await plugin.actorsSearch(term: term);
      holder.make(ProfileViews(res.item2), excludeSelf: insert);
    } catch (e, stacktrace) {
      // TODO
      debugPrint("Error: $e");
      debugPrint("stacktrace: $stacktrace");
    }
  }

  @override
  int get length => holder.actors.length;
}

class NotificationsDataManager extends DataManager {
  final NotificationsDataHolder holder = NotificationsDataHolder();

  @override
  Future<void> getData(bool insert, {String? term}) async {
    try {
      // This getData method called when user push bell widget at bottom.
      if (!read) {
        await plugin.updateSeen(holder.seenAt!);
      }
      await count;
      // TODO cursor, seenAt
      // Tuple2 res = await plugin.listNotifications(cursor: holder.cursor);
      Tuple2 res = await plugin.listNotifications();
      holder.makeNotifications(ListNotifications(res.item2));
      if (holder.uris.isEmpty) {
        return;
      }
      Tuple2 res2 = await plugin.getPosts(holder.uris);
      holder.makePosts(res2.item2["posts"]);
    } catch (e, stacktrace) {
      // TODO
      debugPrint("Error: $e");
      debugPrint("stacktrace: $stacktrace");
    }
  }

  Future<void> get count async {
    Tuple2 res = await plugin.getUnreadCount();
    holder.makeCount(res.item2["count"]);
  }

  bool get read {
    return holder.unreadCount == 0;
  }

  @override
  int get length => holder.notifications.length;
}

abstract class ActorsDataManager extends DataManager {
  final ActorsDataHolder holder = ActorsDataHolder();

  @override
  int get length => holder.actors.length;
}

class FollowsDataManager extends ActorsDataManager {
  // insert :excludeSelf(login user)
  @override
  Future<void> getData(bool insert, {String? term}) async {
    String actor = term!;
    try {
      // String? cursor = holder.cursor; // TODO cursor, limit
      FollowsResponse res = await plugin.followings(actor);
      holder.make(res.graph, excludeSelf: insert);
    } catch (e, stacktrace) {
      // TODO
      debugPrint("Error: $e");
      debugPrint("stacktrace: $stacktrace");
    }
  }
}

class FollowersDataManager extends ActorsDataManager {
  // insert :excludeSelf(login user)
  @override
  Future<void> getData(bool insert, {String? term}) async {
    String actor = term!;
    try {
      // String? cursor = holder.cursor; // TODO cursor, limit
      FollowersResponse res = await plugin.followers(actor);
      holder.make(res.graph, excludeSelf: insert);
    } catch (e, stacktrace) {
      // TODO
      debugPrint("Error: $e");
      debugPrint("stacktrace: $stacktrace");
    }
  }
}
