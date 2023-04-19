import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/line.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';

class Timelines {
  final BuildContext context;
  final Map jsonMap;
  Timelines(this.context, this.jsonMap);

  List<Widget> listview() {
    List<Widget> widgets = [];
    Timeline tl = Timeline(jsonMap);
    tl.setLines();
    for (var feed in tl.lines) {
      Line line = Line(context, feed);
      widgets.add(line.build());
    }
    return widgets;
  }
}

class Timeline {
  late List<Feed> lines = [];
  final List<dynamic> feed;
  final String cursor;

  Timeline(Map map)
      : feed = map["feed"],
        cursor = map["cursor"];
  void setLines() {
    for (var element in feed) {
      lines.add(Feed(element));
    }
  }
}

class Feed {
  final Post post;
  // final Reply? reply;
  Feed(Map map) : post = Post(map["post"]);
  // reply = Reply(map["reply"]);
}

class Post {
  final String uri;
  final String cid;
  final Author author;
  final Record record;
  int replyCount;
  int repostCount;
  int likeCount;
  DateTime indexedAt;
  Viewer viewer;
  List? labels;
  Post(Map map)
      : uri = map["uri"],
        cid = map["cid"],
        author = Author(map["author"]),
        record = Record(map["record"]),
        replyCount = map["replyCount"],
        repostCount = map["repostCount"],
        likeCount = map["likeCount"],
        indexedAt = fromIso8601(map["indexedAt"]),
        viewer = Viewer(map["viewer"]),
        labels = map["labels"];
}

class Reply {
  // TODO
  Reply(Map map);
}

class Author {
  String did;
  String handle;
  String? displayName;
  String? avatar;
  Viewer viewer;
  List? labels;
  Author(Map map)
      : did = map["did"],
        handle = map["handle"],
        displayName = map["displayName"],
        avatar = map["avatar"],
        viewer = Viewer(map["viewer"]),
        labels = map["labels"];
}

class Viewer {
  bool? muted;
  String? following;
  String? followedBy;
  Viewer(Map map)
      : muted = map["muted"],
        following = map["following"],
        followedBy = map["followedBy"];
}

class Record {
  String text;
  String type;
  DateTime createdAt;
  Reply? reply;
  Record(Map map)
      : text = map["text"],
        type = map["\$type"],
        reply = map["reply"],
        createdAt = fromIso8601(map["createdAt"]);
}
