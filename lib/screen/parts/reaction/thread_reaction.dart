import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';

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
  ThreadReactionState(ThreadReaction value) : super(value);

  void reply() {
    value = value.renew;
  }

  void repost() {
    // TODO
    value = value.renew;
  }

  void like() {
    // TODO
    value = value.renew;
  }
}
