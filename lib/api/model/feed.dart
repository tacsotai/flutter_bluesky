import 'package:flutter_bluesky/api/model/actor.dart';

class Feed {
  final Post post;
  // final Reply? reply;
  Feed(Map map) : post = Post(map["post"]);
  // reply = Reply(map["reply"]);
}

class Post {
  final String uri;
  final String cid;
  final ProfileViewBasic author;
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
        author = ProfileViewBasic(map["author"]),
        record = Record(map["record"]),
        replyCount = map["replyCount"],
        repostCount = map["repostCount"],
        likeCount = map["likeCount"],
        indexedAt = DateTime.parse((map["indexedAt"])),
        viewer = Viewer(map["viewer"]),
        labels = map["labels"];
}

class Reply {
  // TODO
  Reply(Map map);
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
        createdAt = DateTime.parse((map["createdAt"]));
}
