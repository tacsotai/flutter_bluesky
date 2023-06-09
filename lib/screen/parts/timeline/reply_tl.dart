import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/avatar.dart';
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

class ReplyTimeline extends ReplyTL with Common {
  @override
  Widget? build(BuildContext context) {
    return paddingLR([replyAvatar(context)], content(parent));
  }

  Widget replyAvatar(BuildContext context) {
    // TODO height is solid, so make it flexible.
    // debugPrint("post.record.text.length: ${post.record.text.length}");
    return Column(children: [
      Avatar(context).net(parent.author).profile,
      Container(
          width: 1,
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.grey,
          ))
    ]);
  }

  @override
  List<Widget> content(Post post) {
    return [
      Header(author: post.author, createdAt: post.record.createdAt),
      replyHeader,
      Body(post: post),
      Footer(post: post),
    ];
  }

  Widget get replyHeader {
    return Row(children: [
      const Icon(Icons.reply, color: Colors.grey),
      Expanded(
          child: Text(
              tr('reply.to',
                  args: [post.author.displayName ?? post.author.handle]),
              style: const TextStyle(color: Colors.grey)))
    ]);
  }
}
