import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/post_tl.dart';
import 'package:flutter_bluesky/screen/parts/timeline/reason_tl.dart';
import 'package:flutter_bluesky/screen/parts/timeline/reply_tl.dart';

// There are 3 pieces at Feed : post, reply?, reason?
ReasonTL? customReasonTL;
ReplyTL? customReplyTL;
PostTL? customPostTL;

class Timeline extends StatelessWidget {
  final Feed feed;
  const Timeline(this.feed, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    if (feed.reason != null) {
      appendReason(context, widgets, feed.reason!.by);
    }
    if (feed.reply != null) {
      appendReply(context, widgets, feed.reply!.parent, feed.post);
    }
    appendPost(context, widgets, feed.post);
    return Column(
      children: widgets,
    );
  }

  void appendReason(
      BuildContext context, List<Widget> widgets, ProfileViewBasic actor) {
    ReasonTL tl = customReasonTL ?? ReasonTimeline();
    tl.setActor(actor);
    widgets.add(tl.build(context)!);
  }

  void appendReply(
      BuildContext context, List<Widget> widgets, Post parent, Post post) {
    ReplyTL tl = customReplyTL ?? ReplyTimeline();
    tl.setParent(parent);
    tl.setPost(post);
    widgets.add(tl.build(context)!);
  }

  void appendPost(BuildContext context, List<Widget> widgets, Post post) {
    PostTL tl = customPostTL ?? PostTimeline();
    tl.setPost(post);
    widgets.add(tl.build(context));
  }
}
