import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/facet.dart';
import 'package:flutter_bluesky/screen/parts/link/link_widget.dart';
import 'package:flutter_bluesky/util/facet_util.dart';

// This class return content with hyperlink
// if the content contains 'https://' or 'http://'.
class HyperLink extends LinkWidget {
  final String text;

  HyperLink(this.text, {double? fontSize}) : super(fontSize: fontSize);

  @override
  Widget get withLink {
    List<RegExpMatch> matches = FacetUtil.linkReg.allMatches(text).toList();
    if (matches.isEmpty) {
      return Text(text);
    }

    int start = 0;
    for (RegExpMatch match in matches) {
      if (match.start > start) {
        addText(text.substring(start, match.start));
      }
      addLink(extractNonUrlText(match.group(0)!), Link(link, match.group(0)!));
      start = match.end;
    }

    if (start < text.length) {
      addText(text.substring(start, text.length));
    }

    return richText;
  }

  String extractNonUrlText(String content) {
    String convertedText = content.replaceAllMapped(FacetUtil.linkReg, (match) {
      String url = match.group(0)!;
      Uri uri = Uri.parse(url);
      String domain = uri.host;
      return domain;
    });
    return convertedText;
  }
}
