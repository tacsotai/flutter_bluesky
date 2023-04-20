import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';

class Timeline {
  final BuildContext context;
  final Feed feed;
  Timeline(this.context, this.feed);

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
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [header(feed), body(feed), footer(feed)],
        ));
  }

  Widget header(Feed feed) {
    return Row(
      children: [
        Text("test"),
        // Text(feed.post.author.displayName),
        const Spacer(),
        Expanded(
          child: Text(feed.post.author.handle),
        ),
        const Spacer(),
        Expanded(
          child: Text(datetime(context, feed.post.record.createdAt)),
        )
      ],
    );
  }

  Widget body(Feed feed) {
    return Row(
      children: [
        Expanded(
            child: Text(
          feed.post.record.text,
          style: const TextStyle(fontSize: 16.0),
        )),
        // const Spacer(),
      ],
    );
  }

  Widget footer(Feed feed) {
    return Row(
      children: [
        Text(feed.post.replyCount.toString()),
        const Spacer(),
        Text(feed.post.repostCount.toString()),
        const Spacer(),
        Text(feed.post.likeCount.toString()),
        const Spacer(),
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
