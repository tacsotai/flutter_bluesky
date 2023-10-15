// import 'package:flutter/foundation.dart';
import 'package:flutter_bluesky/api/model/facet.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'dart:convert';

class FacetUtil {
  static final linkReg = RegExp(r"https?://[\w!?=/+\-_~;.,*&@#$%()'[\]]+");
  static final mentionReg = RegExp(r"@\w+[a-z.]+" + plugin.domain);
  static Future<void> modify(String text, Map<String, dynamic> record) async {
    FacetsManager manager = FacetsManager(text);
    await manager.createFacets();
    if (manager.facets.isNotEmpty) {
      record["facets"] = manager.facets;
    }
    record["text"] = manager.text;
  }
}

// post text, profile descliption, etc...
class FacetsManager {
  static const int overLength = 40;
  static const int trim = 2;
  String text;
  List<Map> facets = [];
  FacetsManager(this.text);

  Future<void> createFacets() async {
    await createLink();
    await createMention();
  }

  Future<void> createLink() async {
    RegExpMatch? match = FacetUtil.linkReg.firstMatch(text);
    if (match != null) {
      String part = text.substring(match.start, match.end);
      // debugPrint("part: $part");
      int end = match.start + modify(part).length;
      int byteStart = len(match.start);
      int byteEnd = len(end);
      await addFacet({}, part, byteStart, byteEnd, link);
      // debugPrint("text: $text");
      await createLink(); // this is recursive logic
    }
  }

  Future<void> createMention() async {
    List<RegExpMatch> matches = FacetUtil.mentionReg.allMatches(text).toList();
    for (RegExpMatch match in matches) {
      String part = text.substring(match.start, match.end);
      int byteStart = len(match.start);
      int byteEnd = len(match.end);
      await addFacet({"\$type": facet}, part, byteStart, byteEnd, mention);
    }
  }

  Future<void> addFacet(
      Map map, String part, int byteStart, int byteEnd, String type) async {
    map["index"] = {"byteStart": byteStart, "byteEnd": byteEnd};
    map["features"] = await features(type, part);
    facets.add(map);
  }

  String modify(String part) {
    String modified = part;
    modified = modified.replaceFirst(RegExp(r"https?://"), "");
    modified = over(modified, overLength);
    text = text.replaceFirst(part, modified);
    return modified;
  }

  int len(int pos) {
    return utf8.encode(text.substring(0, pos)).length;
  }

  String over(String modified, int len) {
    return modified.length > len
        ? "${modified.substring(0, len - trim)}..."
        : modified;
  }

  Future<List<Map>> features(String type, String part) async {
    List<Map> list = [];
    String key = type == mention ? "did" : "uri";
    String value = type == mention ? await plugin.did(part) : part;
    Map map = {key: value, "\$type": type};
    list.add(map);
    return list;
  }
}
