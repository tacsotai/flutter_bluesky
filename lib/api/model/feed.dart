import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/embed.dart';
import 'package:flutter_bluesky/api/model/record.dart';
// lexicons/app/bsky/feed/defs.json
// feedViewPost

class FeedResponse {
  String? cursor;
  List feed = [];

  FeedResponse(Map body)
      : cursor = body["cursor"],
        feed = body["feed"];
}

//app.bsky.feed.defs#threadViewPost
class ThreadResponse {
  final Thread thread;
  ThreadResponse(Map map) : thread = Thread(map["thread"]);
}

class Thread {
  final String type;
  final Post post;
  final Map? parentMap;
  final List? replyList;
  Thread(Map map)
      : type = map["\$type"],
        post = Post(map["post"]),
        parentMap = map["parent"],
        replyList = map["replies"];

  Thread get parent {
    return Thread(parentMap as Map);
  }

  List<Thread> get replies {
    List<Thread> list = [];
    for (var map in replyList!) {
      list.add(Thread(map));
    }
    return list;
  }
}

class Feed {
  final Post post;
  final Reply? reply;
  final Reason? reason;
  Feed(Map map)
      : post = Post(map["post"]),
        reply = map["reply"] == null ? null : Reply(map["reply"]),
        reason = map["reason"] == null ? null : Reason(map["reason"]);
}

class Post {
  final String uri;
  final String cid;
  final ProfileViewBasic author;
  final Record record;
  Embed? embed;
  int? replyCount;
  int? repostCount;
  int? likeCount;
  final DateTime indexedAt;
  Viewer? viewer;
  List? labels;
  Post(Map map)
      : uri = map["uri"],
        cid = map["cid"],
        author = ProfileViewBasic(map["author"]),
        record = Record(map["record"]),
        embed = map["embed"] == null ? null : Embed(map["embed"]),
        replyCount = map["replyCount"],
        repostCount = map["repostCount"],
        likeCount = map["likeCount"],
        indexedAt = DateTime.parse((map["indexedAt"])),
        viewer = map["viewer"] == null ? null : Viewer(map["viewer"]),
        labels = map["labels"];
}

// app.bsky.feed.viewerState
class Viewer {
  String? repost;
  String? like;
  Viewer(Map map)
      : repost = map["repost"],
        like = map["like"];
}

class Reply {
  final Post root;
  final Post parent;
  Reply(Map map)
      : root = Post(map["root"]),
        parent = Post(map["parent"]);
}

class Reason {
  final DateTime indexedAt;
  final ProfileViewBasic by;

  Reason(Map map)
      : indexedAt = DateTime.parse((map["indexedAt"])),
        by = ProfileViewBasic(map["by"]);
}
