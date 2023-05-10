import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common_embed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common_record.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';

abstract class CommonTimeline {
  final CommonRecord commonRecord = CommonRecord();
  final CommonEmbed commonEmbed = CommonEmbed();

  Widget? build(BuildContext context, Feed feed);

  Widget headerFooter(Widget header, Widget body, Widget footer) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          children: [header, body, footer],
        ));
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

  Widget header(BuildContext context, Post post) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 5, child: name(context, post.author)),
            Flexible(flex: 2, child: when(context, post.record)),
          ],
        ));
  }
}
