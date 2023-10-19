import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/facet.dart';
import 'package:flutter_bluesky/screen/profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

abstract class LinkWidget {
  final List<TextSpan> textSpans = [];
  final double? fontSize;

  LinkWidget({this.fontSize});

  Widget get withLink;

  Widget get richText {
    return RichText(
      selectionColor: Colors.black,
      text: TextSpan(children: textSpans, style: TextStyle(fontSize: fontSize)),
    );
  }

  void addText(String text) {
    textSpans.add(TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.black,
      ),
    ));
  }

  Future<void> _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  void addLink(String text, Link link) {
    textSpans.add(TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.blue,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          _launchUrl(link.uri);
        },
    ));
  }

  void addMention(String text, BuildContext context, Mention mention) {
    textSpans.add(TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.blue,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile(user: mention.did)),
          );
        },
    ));
  }
}
