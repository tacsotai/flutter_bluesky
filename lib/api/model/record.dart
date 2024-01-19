// the part of Post and
// "$type": "app.bsky.embed.record",
import 'package:flutter_bluesky/api/model/embed.dart';
import 'package:flutter_bluesky/api/model/facet.dart';

class Record {
  String text;
  String type;
  DateTime createdAt;
  List? langs;
  List<Facet>? facets;
  SelfLabels? labels;
  List<String>? tags;
  RecordReply? reply;
  RecordEmbed? embed;
  Record(Map map)
      : text = map["text"],
        type = map["\$type"],
        langs = map["langs"],
        facets = map["facets"] == null ? null : Facet.list(map["facets"]),
        labels = map["labels"] == null ? null : SelfLabels(map["labels"]),
        tags = map["tags"],
        reply = map["reply"] == null ? null : RecordReply(map["reply"]),
        embed = map["embed"] == null ? null : RecordEmbed(map["embed"]),
        createdAt = DateTime.parse((map["createdAt"]));
}

class SelfLabels {
  final String type;
  final List<SelfLabel> values;

  SelfLabels(Map map)
      : type = map["type"],
        values = SelfLabel.list(map["values"]);
}

class SelfLabel {
  final String val;
  final Map? content;

  SelfLabel(this.val, this.content);

  static List<SelfLabel> list(List values) {
    List<SelfLabel> selfLabels = [];
    for (Map map in values) {
      selfLabels.add(SelfLabel(map["val"], map["content"]));
    }
    return selfLabels;
  }
}

class RecordReply {
  Map<String, dynamic>? root;
  Map<String, dynamic>? parent;
  RecordReply(Map map)
      : root = map["root"],
        parent = map["parent"];
}
