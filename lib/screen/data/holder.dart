import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/api/model/graph.dart';
import 'package:flutter_bluesky/api/model/notification.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';

class HomeDataHolder extends FeedDataHolder {}

class ProfileDataHolder extends FeedDataHolder {
  late String actor;
  late ProfileViewDetailed detail;
  Map<String, List<String>> specialActors = {};

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

  void make(ProfileViews res, {bool excludeSelf = false}) async {
    actors.clear();
    actors = res.actors;
    if (excludeSelf) {
      exclude(plugin.api.session.did!);
    }
    cursor = res.cursor;
  }

  void exclude(String did) {
    for (ProfileView actor in actors) {
      if (actor.did == did) {
        actors.remove(actor);
        break;
      }
    }
  }
}

class ActorsDataHolder {
  String? cursor;
  List<ProfileView> actors = [];

  void make(Graph graph, {excludeSelf = false}) async {
    actors = graph.actors;
    if (excludeSelf) {
      exclude(plugin.api.session.did!);
    }
  }

  void exclude(String did) {
    for (ProfileView actor in actors) {
      if (actor.did == did) {
        actors.remove(actor);
        break;
      }
    }
  }
}

class NotificationsDataHolder {
  // unreadCount
  String? seenAt;
  int unreadCount = 0;
  // listNotifications
  String? cursor;
  List<Notification> notifications = [];
  Map<String, Notification> dedupeMap = {};
  String uris = "";
  Map<String, Post> posts = {};

  void makeNotifications(bool insert, ListNotifications res) {
    List<Notification> list = res.notifications;
    list.map((notification) => dedupeMap[notification.uri] = notification);
    if (cursor == null) {
      addNotification(false, list);
    }
    // insert or append.
    else {
      if (insert) {
        addNotification(true, list);
      } else {
        if (cursor != res.cursor) {
          addNotification(false, list);
        } else {
          // cursor == resCursor case, Do nothing. Noting change.
        }
      }
    }
    // Finally, set the cursor for next load.
    cursor = res.cursor;
    _makeUris(list);
  }

  void addNotification(bool insert, List<Notification> list) {
    List<Notification> dedupeList = [];
    for (var notification in list) {
      if (dedupeMap[notification.uri] == null) {
        dedupeList.add(notification);
      }
    }
    if (insert) {
      notifications.insertAll(0, dedupeList);
    } else {
      notifications.addAll(dedupeList);
    }
  }

  void _makeUris(List<Notification> list) {
    uris = "";
    StringBuffer sb = StringBuffer();
    for (Notification notification in list) {
      if (needUri(notification)) {
        sb.write("uris[]=${getUri(notification)}&");
      }
    }
    if (sb.length > 8) {
      uris = sb.toString().substring(7, sb.toString().length - 1);
    }
  }

  // Use original post when the reason is "quote" for desplaing embed.
  String? getUri(Notification notification) {
    return usingNotificationUri(notification)
        ? notification.uri
        : notification.reasonSubject;
  }

  bool needUri(Notification notification) {
    return notification.reasonSubject != null ||
        notification.reason == "mention";
  }

  bool usingNotificationUri(Notification notification) {
    return notification.reason == "quote" || notification.reason == "mention";
  }

  void makePosts(List postList) async {
    for (Map map in postList) {
      Post post = Post(map);
      posts[post.uri] = post;
    }
  }

  void makeCount(int count) {
    seenAt = DateTime.now().toUtc().toIso8601String();
    unreadCount = count;
  }
}
