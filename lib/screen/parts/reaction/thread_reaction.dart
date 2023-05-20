import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:flutter_bluesky/screen/parts/reaction/like.dart';
import 'package:flutter_bluesky/screen/parts/reaction/reply.dart';
import 'package:flutter_bluesky/screen/parts/reaction/repost.dart';
import 'package:flutter_bluesky/api/model/feed.dart' as feed;

class ThreadReaction {
  final Reaction reply;
  final Reaction repost;
  final Reaction like;

  ThreadReaction(
      {required this.reply, required this.repost, required this.like});

  ThreadReaction get renew {
    return ThreadReaction(reply: reply, repost: repost, like: like);
  }
}

class ThreadReactionState extends ValueNotifier<ThreadReaction> {
  final BuildContext context;
  final feed.Post post;
  ThreadReactionState(ThreadReaction value, this.context, this.post)
      : super(value);

  void reply() async {
    await _action(ReplyReaction(value.reply, context, post));
  }

  void repost() async {
    await _action(RepostReaction(value.repost, context, post));
  }

  void like() async {
    await _action(LikeReaction(value.like, context, post));
  }

  Future<void> _action(AbstractReaction reaction) async {
    await reaction.exec();
    value = value.renew;
  }
}
