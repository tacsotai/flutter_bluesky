import 'package:flutter_bluesky/api/model/actor.dart';

// lexicons/app/bsky/feed/defs.json
// feedViewPost
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
  int replyCount;
  int repostCount;
  int likeCount;
  final DateTime indexedAt;
  Viewer viewer;
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

class Embed {
  String type; // other program use this for judge.
  final Object? images;
  Embed(Map map)
      : type = map["\$type"],
        images = map["images"];

  List<Internal> get internals {
    List<Internal> list = [];
    for (var map in images as List) {
      list.add(Internal(map));
    }
    return list;
  }

  External external() {
    return External(images as Map);
  }

  Record record() {
    return Record(images as Map);
  }

  RecordWithMedia recordWithMedia() {
    return RecordWithMedia(images as Map);
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

// "$type": "app.bsky.embed.recordWithMedia#view",
class RecordWithMedia {
  Record record;
  Media media;
  RecordWithMedia(Map map)
      : record = map["record"],
        media = map["media"];
}

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
  CidUri root;
  CidUri parent;
  RecordReply(Map map)
      : root = CidUri(map["root"]),
        parent = CidUri(map["parent"]);
}

class CidUri {
  String cid;
  String uri;
  CidUri(Map map)
      : cid = map["cid"],
        uri = map["uri"];
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
