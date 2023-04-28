import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/data/holder.dart';
import 'package:tuple/tuple.dart';

class HomeDataManager {
  final HomeDataHolder holder = HomeDataHolder();
  Future<void> getData(bool insert) async {
    try {
      String? cursor = insert ? null : holder.cursor;
      Tuple2 res = await plugin.timeline(cursor: insert ? null : cursor);
      holder.makeFeeds(insert, FeedResponse(res.item2));
    } catch (e) {
      print(e); // TODO
    }
  }
}

class ProfileDataManager {
  final ProfileDataHolder holder = ProfileDataHolder();
  Future<void> getData(bool insert) async {
    try {
      await makeProfile();
      await makeFeed(insert);
    } catch (e) {
      print(e); // TODO
    }
  }

  Future<void> makeProfile() async {
    Tuple2 res = await plugin.getProfile(holder.user);
    holder.makeProfile(res.item2);
  }

  Future<void> makeFeed(bool insert) async {
    String? cursor = insert ? null : holder.cursor;
    Tuple2 res = await plugin.getAuthorFeed(30, holder.user, cursor: cursor);
    holder.makeFeeds(insert, FeedResponse(res.item2));
  }
}
