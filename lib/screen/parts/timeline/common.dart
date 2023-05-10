import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common_base.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';

abstract class CommonTimeline extends CommonBase {
  Widget? build(BuildContext context, Feed feed);

  Widget body(BuildContext context, Post post) {
    List<Widget> widgets = [];
    appendRecord(widgets, post.record);
    appendEmbed(context, widgets, post.embed);
    return Column(children: widgets);
  }

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

  Widget footer(BuildContext context, Post post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        reply(context, post),
        repost(context, post),
        like(context, post),
        more(context, post),
      ],
    );
  }
}
