import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';
import 'package:flutter_bluesky/screen/parts/timeline/body.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';

abstract class ThreadTL {
  Post? parent;
  late Post post;
  List<Thread> replies = [];

  void setParent(Post parent) {
    this.parent = parent;
  }

  void setPost(Post post) {
    this.post = post;
  }

  void setReplies(List<Thread> replies) {
    this.replies.addAll(replies);
  }

  List<Widget> build();
}

class ThreadTimeline extends ThreadTL {
  @override
  List<Widget> build() {
    List<Widget> widgets = [];
    appendParent(widgets);
    appendPost(widgets);
    appendReplies(widgets);
    List<Widget> outlineWidgets = [];
    for (var widget in widgets) {
      outlineWidgets.add(outline(widget));
    }
    return outlineWidgets;
  }

  void appendParent(List<Widget> widgets) {
    if (parent != null) {
      widgets.add(postTL(parent!));
    }
  }

  void appendPost(List<Widget> widgets) {
    widgets.add(threadTL(post));
  }

  void appendReplies(List<Widget> widgets) {
    for (var reply in replies) {
      // TODO reply.parent or reply.reply
      widgets.add(postTL(reply.post));
    }
  }

  Widget threadTL(Post post) {
    return Column(
      children: [
        mainHeader(post),
        mainContentBody(post),
        const Divider(height: 0.5),
        mainLike(post),
        const Divider(height: 0.5),
        ThreadAction(post: post)
      ],
    );
  }

  Widget mainContentBody(Post post) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Body(post: post, fontSize: 18));
  }

  Widget mainHeader(Post post) {
    return Row(children: [
      avator(post.author.avatar),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
              child: Header(
                  author: post.author, createdAt: post.record.createdAt))),
    ]);
  }

  Widget mainLike(Post post) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              "${post.likeCount} ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Expanded(
                child: Text("like", style: TextStyle(color: Colors.grey))),
          ],
        ));
  }

  Widget threadFrame(Widget content) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(10),
        child: Padding(padding: const EdgeInsets.all(5), child: content),
      ),
      const Divider(height: 0.5)
    ]);
  }
}

class ThreadAction extends Footer {
  const ThreadAction({super.key, required super.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        iconTheme(context, 'Reply', Icons.chat_bubble_outline),
        iconTheme(context, 'Repost', Icons.repeat),
        iconTheme(context, 'Like', Icons.favorite_outline),
      ],
    );
  }
}
