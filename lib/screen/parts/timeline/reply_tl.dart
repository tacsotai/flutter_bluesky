import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';
import 'package:flutter_bluesky/screen/parts/timeline/body.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';

abstract class ReplyTL {
  late Post post;
  late Post parent;
  void setPost(Post post) {
    this.post = post;
  }

  void setParent(Post parent) {
    this.parent = parent;
  }

  Widget? build(BuildContext context);
}

class ReplyTimeline extends ReplyTL {
  @override
  Widget? build(BuildContext context) {
    return paddingLR([replyAvator(context)], content);
  }

  Widget replyAvator(BuildContext context) {
    // TODO height is solid, so make it flexible.
    // debugPrint("post.record.text.length: ${post.record.text.length}");
    return Column(children: [
      avator(context, parent.author.avatar),
      Container(
          width: 1,
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.grey,
          ))
    ]);
  }

  List<Widget> get content {
    return [
      Header(author: parent.author, createdAt: parent.record.createdAt),
      replyHeader,
      Body(post: parent),
      Footer(post: parent),
    ];
  }

  Widget get replyHeader {
    return Row(children: [
      const Icon(Icons.reply, color: Colors.grey),
      Expanded(
          child: Text('Reply to ${post.author.displayName}',
              style: const TextStyle(color: Colors.grey)))
    ]);
  }
}
