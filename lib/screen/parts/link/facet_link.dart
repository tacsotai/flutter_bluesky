import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/facet.dart';
import 'package:flutter_bluesky/api/model/embed.dart';
import 'package:flutter_bluesky/screen/parts/link/link_widget.dart';
import 'dart:convert';

// This class return content with hyperlink
// if the content contains 'https://' or 'http://'.
class FacetLink extends LinkWidget {
  final BuildContext context;
  final Record record;

  FacetLink(this.record, this.context, {double? fontSize})
      : super(fontSize: fontSize);

  @override
  Widget get withLink {
    if (record.facets == null) {
      return Text(record.text);
    } else {
      makeRichText();
      return richText;
    }
  }

  void makeRichText() {
    FacetInfoConverter converter = FacetInfoConverter(record);
    for (FacetInfo info in converter.infos) {
      if (info.feature == null) {
        addText(info.text);
      } else {
        if (info.feature!.type == mention) {
          addMention(info.text, context, info.feature as Mention);
        } else {
          addLink(info.text, info.feature as Link);
        }
      }
    }
  }
}

class FacetInfoConverter {
  final Record record;
  final List<int> bytes;

  FacetInfoConverter(this.record) : bytes = utf8.encode(record.text);

  List<FacetInfo> get infos {
    List<FacetInfo> list = [];
    List<Facet> facets = sort();
    for (var i = 0; i < facets.length; i++) {
      makeInfos(list, facets, i);
    }
    return list;
  }

  void makeInfos(List<FacetInfo> list, List<Facet> facets, int i) {
    Facet facet = facets[i];
    int start = facets[i].index.byteStart;
    int end = facets[i].index.byteEnd;
    if (i == 0 && facet.index.byteStart != 0) {
      list.add(info(0, start));
    }
    list.add(info(start, end, facet: facet));
    try {
      Facet next = facets[i + 1];
      list.add(info(end, next.index.byteStart));
    } catch (e) {
      // the end to make list;
      list.add(info(end, bytes.length));
    }
  }

  FacetInfo info(int start, int end, {Facet? facet}) {
    if (facet == null) {
      return FacetInfo(start, end, text(start, end), null);
    } else {
      return FacetInfo(start, end, text(start, end), facet.features[0]);
    }
  }

  List<Facet> sort() {
    Map<int, Facet> map = {};
    for (Facet facet in record.facets!) {
      map[facet.index.byteStart] = facet;
    }
    map = SplayTreeMap.from(map, (a, b) => a.compareTo(b));
    return map.values.toList();
  }

  String text(int start, int end) {
    return utf8.decode(bytes.getRange(start, end).toList());
  }
}

class FacetInfo {
  final int start;
  final int end;
  final String text;
  final Feature? feature;

  FacetInfo(this.start, this.end, this.text, this.feature);
}
