import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';

class PostTimeline extends CommonTimeline {
  @override
  Widget build(BuildContext context, Feed feed) {
    return Row(
      children: [
        avator(feed.post.author.avatar),
        sizeBox,
        Expanded(
            child: headerFooter(
          header(context, feed.post),
          body(feed.post),
          footer(context, feed.post),
        )),
      ],
    );
  }

  Widget body(Post post) {
    List<Widget> widgets = [];
    appendText(widgets, post.record);
    appendEmbed(widgets, post.embed);
    return Column(children: widgets);
  }

  void appendText(List<Widget> widgets, Record record) {
    Widget text = Row(
      children: [
        Expanded(child: Text(record.text)),
      ],
    );
    widgets.add(text);
  }

  void appendEmbed(List<Widget> widgets, Embed? embed) {
    if (embed == null) {
      return;
    }
    debugPrint("embed.type: ${embed.type}");
    if (embed.type == 'app.bsky.embed.images#view') {
      for (Internal internal in embed.internals) {
        widgets.add(Image.network(internal.thumb));
      }
    }
    // External
  }
}
