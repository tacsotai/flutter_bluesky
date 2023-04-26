import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/home/timeline.dart';
import 'package:flutter_test/flutter_test.dart';

final Map fakeRes1 = {
  "feed": [
    {
      "post": {
        "uri":
            "at://did:plc:u5xrfsqb6d2xrph6t4uwwe2h/app.bsky.feed.post/3jsodhtjgp22b",
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
        "uri":
            "at://did:plc:u5xrfsqb6d2xrph6t4uwwe2h/app.bsky.feed.post/3jsodhtjgp22b",
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
final newFeed = Feed(fakeRes1['feed'][0]);
final oldFeed = Feed(fakeRes2['feed'][0]);
const newCursor = '1680751088612::newCursor';
const oldCursor = '1570751088612::oldCursor';
void main() {
  group('Timeline', () {
    late Timeline timeline;
    final fakeFeedList = [newFeed, oldFeed];
    const fakeCursor = newCursor;
    final fakePost = newFeed.post;

    setUp(() {
      timeline = Timeline();
    });

    test('should add all feeds when cursor is null', () {
      // action
      timeline.makeFeeds(true, fakeCursor, fakeFeedList);

      // assert
      expect(timeline.feeds, equals(fakeFeedList));
    });

    test('insertFeeds insert = true', () {
      // setup
      timeline.cursor = oldCursor;
      timeline.feeds = [oldFeed];

      final newFeedList = [newFeed];
      final resultFeedList = [newFeed, oldFeed];

      // action
      timeline.makeFeeds(true, newCursor, newFeedList);

      // assert
      expect(timeline.feeds, equals(resultFeedList));
    });

    test('insertFeeds insert = false', () {
      // setup
      timeline.cursor = oldCursor;
      timeline.feeds = [oldFeed];

      final newFeedList = [newFeed];
      final resultFeedList = [oldFeed];

      // action
      timeline.makeFeeds(false, newCursor, newFeedList);

      // assert
      expect(timeline.feeds, equals(resultFeedList));
    });

    test('insertFeeds latest < current', () {
      // setup
      timeline.cursor = newCursor;
      timeline.feeds = [oldFeed];

      final newFeedList = [newFeed];
      final resultFeedList = [oldFeed, newFeed];

      // action
      timeline.makeFeeds(false, oldCursor, newFeedList);

      // assert
      expect(timeline.feeds, equals(resultFeedList));
    });

    test('should do nothing when cursor is equal to latest cursor', () {
      // setup
      timeline.cursor = fakeCursor;

      // action
      timeline.makeFeeds(true, fakeCursor, fakeFeedList);

      // assert
      expect(timeline.feeds, isEmpty);
    });
  });
}
