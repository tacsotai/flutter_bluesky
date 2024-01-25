import 'package:flutter_bluesky/api/model/actor.dart';

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

  List<Images> get images {
    List<Images> list = [];
    for (var map in imagesObj as List) {
      list.add(Images(map));
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
class Images {
  String thumb;
  String fullsize;
  String alt;
  Images(Map map)
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
  List? embedList;
  RecordView(Map map)
      : type = map["\$type"],
        uri = map["uri"],
        cid = map["cid"],
        author = ProfileViewBasic(map["author"]),
        value = Value(map["value"]),
        labels = map["labels"],
        indexedAt = DateTime.parse((map["indexedAt"])),
        embedList = map["embeds"];

  List<Embed> get embeds {
    List<Embed> list = [];
    for (var map in embedList as List) {
      list.add(Embed(map));
    }
    return list;
  }
}

class Value {
  String text;
  String type;
  RecordEmbed? embed;
  List? langs;
  DateTime createdAt;
  Value(Map map)
      : text = map["text"],
        type = map["\$type"],
        embed = map["embed"] == null ? null : RecordEmbed(map["embed"]),
        langs = map["langs"],
        createdAt = DateTime.parse((map["createdAt"]));
}

// "id": "app.bsky.embed.recordWithMedia"
class RecordWithMedia {
  String type;
  RecordView record;
  Media media;
  RecordWithMedia(Map map)
      : type = map["\$type"],
        record = RecordView(map["record"]),
        media = Media(map["media"]);
}

// "$type": "app.bsky.embed.recordWithMedia#view",
class Media {
  List<Images>? images;
  External? external;

  Media(Map map)
      : images = map["images"],
        external = map["external"];
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
