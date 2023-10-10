import 'package:flutter_bluesky/api/model/actor.dart';

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
        viewer = Viewer(map["viewer"]),
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

class Embed {
  // other program use this for judge.
  String type;
  // Check null check, then access methods: internals, external, etc.
  final Object? imagesObj;
  final Object? externalObj;
  final Object? recordObj;
  final Object? mediaObj;
  Embed(Map map)
      : type = map["\$type"],
        imagesObj = map["images"],
        externalObj = map["external"],
        recordObj = map["record"],
        mediaObj = map["media"];

  List<Internal> get internals {
    List<Internal> list = [];
    for (var map in imagesObj as List) {
      list.add(Internal(map));
    }
    return list;
  }

  External get external {
    return External(externalObj as Map);
  }

  RecordView get record {
    return RecordView(recordObj as Map);
  }

  Media get media {
    return Media(mediaObj as Map);
  }
}

// "$type": "app.bsky.embed.images#view",
class Internal {
  String thumb;
  String fullsize;
  String alt;
  Internal(Map map)
      : thumb = map["thumb"],
        fullsize = map["fullsize"],
        alt = map["alt"];
}

// "$type": "app.bsky.embed.external#view",
class External {
  String uri;
  String title;
  String description;
  External(Map map)
      : uri = map["uri"],
        title = map["title"],
        description = map["description"];
}

// app.bsky.embed.record#view
class RecordView {
  final String type;
  final String uri;
  final String cid;
  final ProfileViewBasic author;
  final Value value;
  List? labels;
  final DateTime indexedAt;
  List? embeds;
  RecordView(Map map)
      : type = map["\$type"],
        uri = map["uri"],
        cid = map["cid"],
        author = ProfileViewBasic(map["author"]),
        value = Value(map["value"]),
        labels = map["labels"],
        indexedAt = DateTime.parse((map["indexedAt"])),
        embeds = map["embeds"];
}

class Value {
  String text;
  String type;
  DateTime createdAt;
  Value(Map map)
      : text = map["text"],
        type = map["\$type"],
        createdAt = DateTime.parse((map["createdAt"]));
}

// "$type": "app.bsky.embed.recordWithMedia#view",
class Media {
  List<Internal>? images;
  External? external;

  Media(Map map)
      : images = map["images"],
        external = map["external"];
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

// the part of Post and
// "$type": "app.bsky.embed.record",
class Record {
  String text;
  String type;
  DateTime createdAt;
  RecordReply? reply;
  RecordEmbed? embed;
  Record(Map map)
      : text = map["text"],
        type = map["\$type"],
        reply = map["reply"] == null ? null : RecordReply(map["reply"]),
        embed = map["embed"] == null ? null : RecordEmbed(map["embed"]),
        createdAt = DateTime.parse((map["createdAt"]));
}

class RecordReply {
  Map<String, dynamic>? root;
  Map<String, dynamic>? parent;
  RecordReply(Map map)
      : root = map["root"],
        parent = map["parent"];
}

class RecordEmbed {
  String type;
  List? imgs;
  RecordEmbed(Map map)
      : type = map["\$type"],
        imgs = map["images"];

  List<RecordEmbedImage> get images {
    List<RecordEmbedImage> list = [];
    for (var map in imgs as List) {
      list.add(RecordEmbedImage(map));
    }
    return list;
  }
}

class RecordEmbedImage {
  String alt;
  Map image;
  RecordEmbedImage(Map map)
      : alt = map["alt"],
        image = map["image"];
}
