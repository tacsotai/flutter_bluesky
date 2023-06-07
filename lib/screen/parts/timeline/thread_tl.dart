import 'package:acceptable/acceptable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/avatar.dart';
import 'package:flutter_bluesky/screen/parts/reaction/like.dart';
import 'package:flutter_bluesky/screen/parts/reaction/repost.dart';
import 'package:flutter_bluesky/screen/parts/reaction/thread_reaction.dart';
import 'package:flutter_bluesky/screen/parts/timeline/body.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluesky/screen/parts/reaction/reply.dart' as act;

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

  List<Widget> build(BuildContext context);
}

class ThreadTimeline extends ThreadTL with Common {
  @override
  List<Widget> build(BuildContext context) {
    List<Widget> widgets = [];
    appendParent(context, widgets);
    appendPost(widgets);
    appendReplies(context, widgets);
    List<Widget> outlineWidgets = [];
    for (var widget in widgets) {
      outlineWidgets.add(outline(widget));
    }
    return outlineWidgets;
  }

  void appendParent(BuildContext context, List<Widget> widgets) {
    if (parent != null) {
      widgets.add(postTL(context, parent!));
    }
  }

  void appendPost(List<Widget> widgets) {
    widgets.add(ThreadMain(post: post));
  }

  void appendReplies(BuildContext context, List<Widget> widgets) {
    for (var reply in replies) {
      // TODO reply.parent or reply.reply
      widgets.add(postTL(context, reply.post));
    }
  }
}

class ThreadMain extends StatelessWidget {
  final Post post;
  const ThreadMain({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [header(context), body, footer],
    );
  }

  Widget get body {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Body(post: post, fontSize: 18));
  }

  Widget header(BuildContext context) {
    return Row(children: [
      Avatar(context, post.author.avatar).profile,
      Expanded(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
              child: Header(
                  author: post.author, createdAt: post.record.createdAt))),
    ]);
  }

  Widget get footer {
    ThreadReaction reaction = ThreadReaction(
      reply: act.Reply(post).reaction,
      repost: Repost(post).reaction,
      like: Like(post).reaction,
    );
    return ChangeNotifierProvider(
      child: const ThreadFooter(),
      create: (context) => ThreadReactionState(reaction, context, post),
    );
  }
}

class ThreadFooter extends AcceptableStatefulWidget {
  const ThreadFooter({Key? key}) : super(key: key);

  @override
  ThreadFooterScreen createState() => ThreadFooterScreen();
}

class ThreadFooterScreen extends AcceptableStatefulWidgetState<ThreadFooter> {
  late ThreadReaction reaction;
  @override
  void acceptProviders(Accept accept) {
    accept<ThreadReactionState, ThreadReaction>(
      watch: (state) => state.value,
      apply: (value) => reaction = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0.5),
        counts,
        const Divider(height: 0.5),
        reactions,
      ],
    );
  }

  Widget get counts {
    List<Widget> widgets = [];
    if (reaction.like.count != 0) {
      widgets.add(_text(reaction.like.count, "like"));
    }
    if (reaction.repost.count != 0) {
      widgets.add(_text(reaction.repost.count, "repost"));
    }
    return Row(children: widgets);
  }

  Widget _text(int count, String st) {
    List<Widget> widgets = [
      Text("$count ", style: const TextStyle(fontWeight: FontWeight.bold)),
      Text(st, style: const TextStyle(color: Colors.grey)),
    ];
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Row(children: widgets));
  }

  Widget get reactions {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      button(reaction.reply, context.read<ThreadReactionState>().reply),
      button(reaction.repost, context.read<ThreadReactionState>().repost),
      button(reaction.like, context.read<ThreadReactionState>().like),
    ]);
  }
}
