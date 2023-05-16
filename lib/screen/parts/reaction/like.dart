import 'package:acceptable/acceptable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';

class Like extends ReactionBody {
  Like()
      : super(
          color: Colors.pink,
          tooltip: tr("reaction.like"),
          on: const Icon(Icons.favorite),
          off: const Icon(Icons.favorite_outline),
        );
}

class LikeWidget extends AcceptableStatefulWidget {
  const LikeWidget({Key? key}) : super(key: key);

  @override
  LikeScreen createState() => LikeScreen();
}

class LikeScreen extends AcceptableStatefulWidgetState<LikeWidget> {
  late Reaction reaction;

  @override
  void acceptProviders(Accept accept) {
    accept<ReactionState, Reaction>(
      watch: (state) => state.value,
      apply: (value) => reaction = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget(context, reaction);
  }
}
