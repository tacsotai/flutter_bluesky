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
    commonRecord.append(widgets, post.record);
    commonEmbed.append(widgets, post.embed);
    return Column(children: widgets);
  }
}
