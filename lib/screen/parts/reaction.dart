import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart' as feed;
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/reaction/like.dart';
import 'package:flutter_bluesky/screen/parts/reaction/more.dart';
import 'package:flutter_bluesky/screen/parts/reaction/reply.dart';
import 'package:flutter_bluesky/screen/parts/reaction/repost.dart';

class Reaction {
  final Color color;
  final String tooltip;
  final Icon on;
  final Icon off;
  int count;
  String? uri;

  Reaction(
      {required this.color,
      required this.tooltip,
      required this.on,
      required this.off,
      required this.count,
      required this.uri});

  Reaction get renew {
    return Reaction(
        color: color,
        tooltip: tooltip,
        on: on,
        off: off,
        count: count,
        uri: uri);
  }
}

/// [ValueNotifier]
/// set reaction(T newValue) {
///   if (_reaction == newValue) {
///     return;
///   }
///   _reaction = newValue;
///   notifyListeners();
/// }
class ReactionState extends ValueNotifier<Reaction> {
  final BuildContext context;
  final feed.Post post;
  ReactionState(Reaction reaction, this.context, this.post) : super(reaction);

  void reply() async {
    await _action(ReplyReaction(value, context, post));
  }

  void repost() async {
    await _action(RepostReaction(value, context, post));
  }

  void like() async {
    await _action(LikeReaction(value, context, post));
  }

  void more() async {
    await _action(MoreReaction(value, context, post));
  }

  Future<void> _action(AbstractReaction reaction) async {
    checkSession(context);
    await reaction.exec();
    value = reaction.renew;
  }
}

abstract class AbstractReaction {
  final Reaction reaction;
  final BuildContext context;
  final feed.Post post;

  AbstractReaction(this.reaction, this.context, this.post);

  Future<void> exec();

  Reaction get renew {
    return reaction.renew;
  }
}
