import 'package:flutter/cupertino.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/api/model/notification.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/data/holder.dart';
import 'package:tuple/tuple.dart';

abstract class DataManager {
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
    Tuple2 res = await plugin.getProfile(holder.user);
    holder.makeProfile(res.item2);
  }

  Future<void> makeFeed(bool insert) async {
    String? cursor = insert ? null : holder.cursor;
    Tuple2 res =
        await plugin.getAuthorFeed(holder.user, limit: 30, cursor: cursor);
    holder.makeFeeds(insert, FeedResponse(res.item2));
  }
}
