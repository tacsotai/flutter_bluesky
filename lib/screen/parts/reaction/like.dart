import 'package:acceptable/acceptable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:flutter_bluesky/util/reaction_util.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Like extends StatelessWidget {
  final Post post;
  const Like(this.post, {super.key});

  Reaction get reaction {
    return Reaction(
        color: Colors.pink,
        tooltip: tr("reaction.like"),
        on: const Icon(Icons.favorite),
        off: const Icon(Icons.favorite_outline),
        count: post.likeCount!,
        uri: post.viewer!.like);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: const LikeWidget(),
      create: (context) => ReactionState(reaction, context, post),
    );
  }
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
    return withText(reaction, context.read<ReactionState>().like);
  }
}

class LikeReaction extends AbstractReaction {
  LikeReaction(super.reaction, super.context, super.post);

  @override
  Future<void> exec() async {
    // unlike
    if (reaction.uri != null) {
      reaction.count -= 1;
      await plugin.unlike(reaction.uri!);
      reaction.uri = null;
    }
    // like
    else {
      reaction.count += 1;
      Tuple2 res = await plugin.like(post.uri, post.cid);
      reaction.uri = res.item2['uri'];
    }
  }
}
