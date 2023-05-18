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
    if (value.repost.own) {
      value.repost.count -= 1;
    } else {
      value.repost.count += 1;
    }
    value.repost.own = !value.repost.own;
    value = value.renew;
  }

  void like() {
    if (value.like.own) {
      value.like.count -= 1;
    } else {
      value.like.count += 1;
    }
    value.like.own = !value.like.own;
    value = value.renew;
  }
}
