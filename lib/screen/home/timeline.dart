import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:tuple/tuple.dart';

class Timeline {
  String? cursor;
  List<Feed> feeds = [];

  Future<void> getFeeds(bool insert) async {
    Tuple2 res = await plugin.timeline(cursor: insert ? null : cursor);
    String resCursor = res.item2["cursor"];
    List<Feed> list = _getList(res.item2["feed"]);
    makeFeeds(insert, resCursor, list);
    cursor = resCursor;
  }

  void makeFeeds(bool insert, String resCursor, List<Feed> list) {
    if (cursor == null) {
      feeds.addAll(list);
    } else if (cursor != resCursor) {
      int current = int.parse(cursor!.split('::')[0]);
      int latest = int.parse(resCursor.split('::')[0]);
      if (latest < current) {
        feeds.addAll(list);
      } else {
        insertFeeds(insert, latest, list);
      }
    } else {
      // cursor == resCursor case, Do nothing.
    }
  }

  void insertFeeds(bool insert, int latest, List<Feed> list) {
    if (insert) {
      DateTime cursorDate = DateTime.fromMillisecondsSinceEpoch(latest);
      List<Feed> inserts = [];
      for (Feed feed in list) {
        if (feed.post.record.createdAt.isAfter(cursorDate)) {
          inserts.add(feed);
        }
      }
      feeds.insertAll(0, inserts);
    }
  }

  List<Feed> _getList(List feeds) {
    List<Feed> list = [];
    for (var element in feeds) {
      list.add(Feed(element));
    }
    return list;
  }
}
