import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common_post.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';

class ReplyTimeline extends CommonTimeline {
  @override
  Widget? build(BuildContext context, Feed feed) {
    if (feed.reply == null) {
      return null;
    }
    Post parent = feed.reply!.parent;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        replyAvator(parent),
        sizeBox,
        contentFrame(context, feed),
      ],
    );
  }

  Widget replyAvator(Post post) {
    // TODO height is solid, so make it flexible.
    // debugPrint("post.record.text.length: ${post.record.text.length}");
    return Column(children: [
      avator(post.author.avatar),
      Container(
          width: 1,
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.grey,
          ))
    ]);
  }

  @override
  List<Widget> content(BuildContext context, Feed feed) {
    Post parent = feed.reply!.parent;
    return [
      header(context, parent.author, parent.record.createdAt),
      replyHeader(feed.post),
      contentBody(context, parent),
      footer(context, parent),
    ];
  }

  Widget replyHeader(Post original) {
    return Row(children: [
      const Icon(Icons.reply, color: Colors.grey),
      Expanded(
          child: Text('Reply to ${original.author.displayName}',
              style: const TextStyle(color: Colors.grey)))
    ]);
  }
}
