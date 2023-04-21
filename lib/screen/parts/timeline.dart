import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';

class Timeline {
  final BuildContext context;
  final Feed feed;
  Timeline(this.context, this.feed);

  Widget build() {
    return Row(
      children: [
        avator(feed.post.author.avatar),
        sizeBox,
        Expanded(child: content(feed)),
      ],
    );
  }

  Widget content(Feed feed) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          children: [header(feed), body(feed), footer(feed)],
        ));
  }

  Widget header(Feed feed) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 5, child: name(context, feed.post.author)),
            Flexible(flex: 2, child: when(context, feed.post.record)),
          ],
        ));
  }

  Widget body(Feed feed) {
    return Row(
      children: [
        Expanded(
            child: Text(
          feed.post.record.text,
        )),
      ],
    );
  }

  Widget footer(Feed feed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        reply(context, feed.post),
        repost(context, feed.post),
        like(context, feed.post),
        more(context, feed.post),
      ],
    );
  }
}
