import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/timelines.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';

class Line {
  final BuildContext context;
  final Feed feed;
  Line(this.context, this.feed);

  Widget build() {
    return Row(
      children: [
        // avatar(feed.post.author.avatar),
        avatar('https://hoo.bar/sample.png'),
        sizeBox,
        Expanded(child: content(feed)),
      ],
    );
  }

  Widget content(Feed feed) {
    return Column(
      children: [header(feed), body(feed), footer(feed)],
    );
  }

  Widget header(Feed feed) {
    return Row(
      children: [
        Text("test"),
        // Text(feed.post.author.displayName),
        sizeBox,
        Expanded(
          child: Text(feed.post.author.handle),
        ),
        sizeBox,
        Expanded(
          child: Text(datetime(context, feed.post.record.createdAt)),
        )
      ],
    );
  }

  Widget body(Feed feed) {
    return Column(
      // TODO reply
      children: [
        Text(feed.post.record.text),
      ],
    );
  }

  Widget footer(Feed feed) {
    return Row(
      children: [
        Text(feed.post.replyCount.toString()),
        sizeBox,
        Expanded(child: Text(feed.post.repostCount.toString())),
        sizeBox,
        Expanded(child: Text(feed.post.likeCount.toString())),
      ],
    );
  }
}

Widget avatar(String url) {
  return CircleAvatar(
    backgroundImage: NetworkImage(url),
    // backgroundColor: ThemeColors.primary,
    // child: const Icon(Icons.person_outline_rounded),
  );
}
