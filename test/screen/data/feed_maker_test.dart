import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/data/holder.dart';
import 'package:flutter_test/flutter_test.dart';

final Map fakeRes1 = {
  "feed": [
    {
      "post": {
        "uri": "uri1",
        "cid": "bafyreihz6n6gd3gn4h6oqxh6quwv2xjszqkchcefctve2viyh6n7ca4uku",
        "author": {
          "did": "did:plc:u5xrfsqb6d2xrph6t4uwwe2h",
          "handle": "nose.test",
          "viewer": {"muted": false}
        },
        "record": {
          "text": "good postman",
          "\$type": "app.bsky.feed.post",
          "createdAt": "2023-04-10T08:16:04.692Z"
        },
        "replyCount": 0,
        "repostCount": 0,
        "likeCount": 0,
        "indexedAt": "2023-04-11T03:18:08.612Z",
        "viewer": {}
      }
    }
  ],
  "cursor": "1680751088612::newCursor"
};
final Map fakeRes2 = {
  "feed": [
    {
      "post": {
        "uri": "uri2",
        "cid": "bafyreihz6n6gd3gn4h6oqxh6quwv2xjszqkchcefctve2viyh6n7ca4uku",
        "author": {
          "did": "did:plc:u5xrfsqb6d2xrph6t4uwwe2h",
          "handle": "nose.test",
          "viewer": {"muted": false}
        },
        "record": {
          "text": "good postman",
          "\$type": "app.bsky.feed.post",
          "createdAt": "2023-04-10T08:16:04.692Z"
        },
        "replyCount": 0,
        "repostCount": 0,
        "likeCount": 0,
        "indexedAt": "2023-04-11T03:18:08.612Z",
        "viewer": {}
      }
    }
  ],
  "cursor": "1570751088612::oldCursor"
};
final FeedResponse newRes = FeedResponse(fakeRes1);
final FeedResponse oldRes = FeedResponse(fakeRes2);
const newCursor = '1680751088612::newCursor';
const oldCursor = '1570751088612::oldCursor';

List<Feed> convert(FeedResponse res) {
  List<Feed> list = [];
  for (var element in res.feed) {
    Feed feed = Feed(element);
    list.add(feed);
  }
  return list;
}

void main() {
  group('Timeline', () {
    late FeedDataHolder holder;

    setUp(() {
      holder = FeedDataHolder();
    });

    test('makeFeeds initial case', () {
      // setup
      List<Feed> resultFeedList = [];
      resultFeedList.addAll(convert(oldRes));
      // action
      holder.makeFeeds(false, oldRes);

      // assert
      expect(holder.feeds.length, equals(1));
      expect(holder.feeds[0].post.uri, equals(resultFeedList[0].post.uri));
    });

    test('makeFeeds insert case', () {
      // setup
      List<Feed> resultFeedList = [];
      resultFeedList.addAll(convert(newRes));
      resultFeedList.addAll(convert(oldRes));
      holder.cursor = oldCursor;
      holder.feeds.addAll(convert(oldRes));
      // action
      holder.makeFeeds(true, newRes);

      // assert
      expect(holder.feeds.length, equals(2));
      expect(holder.feeds[0].post.uri, equals(resultFeedList[0].post.uri));
      expect(holder.feeds[1].post.uri, equals(resultFeedList[1].post.uri));
    });

    test('makeFeeds append case', () {
      // setup
      List<Feed> resultFeedList = [];
      resultFeedList.addAll(convert(oldRes));
      resultFeedList.addAll(convert(newRes));

      holder.cursor = "hoge";
      holder.feeds.addAll(convert(oldRes));
      // action
      holder.makeFeeds(false, newRes);

      // assert
      expect(holder.feeds.length, equals(2));
      expect(holder.feeds[0].post.uri, equals(resultFeedList[0].post.uri));
      expect(holder.feeds[1].post.uri, equals(resultFeedList[1].post.uri));
    });
  });
}
