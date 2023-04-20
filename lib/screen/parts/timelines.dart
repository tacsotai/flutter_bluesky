import 'package:flutter_bluesky/util/datetime_util.dart';

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
  // Reply? reply;
  Record(Map map)
      : text = map["text"],
        type = map["\$type"],
        // reply = Reply(map["reply"]),
        createdAt = fromIso8601(map["createdAt"]);
}
