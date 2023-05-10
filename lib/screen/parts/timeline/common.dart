import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common_base.dart';

abstract class CommonTimeline extends CommonBase {
  Widget? build(BuildContext context, Feed feed);

  Widget contentFrame(BuildContext context, Feed feed) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content(context, feed),
            )));
  }

  List<Widget> content(BuildContext context, Feed feed) {
    return [
      header(context, feed.post.author, feed.post.record.createdAt),
      body(context, feed.post),
      footer(context, feed.post),
    ];
  }

  Widget body(BuildContext context, Post post) {
    List<Widget> widgets = [];
    appendRecord(widgets, post.record);
    appendEmbed(context, widgets, post.embed);
    return Column(children: widgets);
  }

  void appendRecord(List<Widget> widgets, Record record) {
    Widget text = Row(
      children: [
        Expanded(child: Text(record.text)),
      ],
    );
    widgets.add(text);
  }

  void appendEmbed(BuildContext context, List<Widget> widgets, Embed? embed) {
    if (embed == null) {
      return;
    }
    debugPrint("embed.type: ${embed.type}");
    if (embed.type == 'app.bsky.embed.images#view') {
      internals(widgets, embed);
    } else if (embed.type == 'app.bsky.embed.external#view') {
      // external(widgets, embed);
    } else if (embed.type == 'app.bsky.embed.record#view') {
      record(context, widgets, embed);
    } else if (embed.type == 'app.bsky.embed.recordWithMedia#view') {
      // recordWithMedia(widgets, embed);
    }
  }
}
