import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// This class return content with hyperlink
// if the content contains 'https://' or 'http://'.
class HyperLink {
  RegExp regex = RegExp(r"https?://\S+");
  final String text;

  HyperLink(this.text);

  Widget get withLink {
    List<RegExpMatch> matches = regex.allMatches(text).toList();
    if (matches.isEmpty) {
      return Text(text);
    }

    List<TextSpan> textSpans = [];

    int start = 0;
    for (RegExpMatch match in matches) {
      if (match.start > start) {
        textSpans.add(TextSpan(
          text: text.substring(start, match.start),
          style: const TextStyle(
            color: Colors.black,
          ),
        ));
      }

      textSpans.add(TextSpan(
        text: extractNonUrlText(match.group(0)!),
        style: const TextStyle(
          color: Colors.blue,
          // decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _launchUrl(match.group(0)!);
          },
      ));

      start = match.end;
    }

    if (start < text.length) {
      textSpans.add(TextSpan(
        text: text.substring(start),
      ));
    }

    return RichText(
      selectionColor: Colors.black,
      text: TextSpan(children: textSpans, style: const TextStyle(fontSize: 20)),
    );
  }

  Future<void> _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  String extractNonUrlText(String content) {
    String convertedText = content.replaceAllMapped(regex, (match) {
      String url = match.group(0)!;
      Uri uri = Uri.parse(url);
      String domain = uri.host;
      return domain;
    });
    return convertedText;
  }
}
