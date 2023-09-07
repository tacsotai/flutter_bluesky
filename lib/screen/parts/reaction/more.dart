import 'package:acceptable/acceptable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';

class More extends StatelessWidget {
  final Post post;
  const More(this.post, {super.key});

  Reaction get reaction {
    return Reaction(
        color: Colors.grey,
        tooltip: tr("reaction.more"),
        on: const Icon(Icons.more_horiz),
        off: const Icon(Icons.more_horiz),
        count: 0,
        uri: post.viewer.like);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: const MoreWidget(),
      create: (context) => ReactionState(reaction, context, post),
    );
  }
}

class MoreWidget extends AcceptableStatefulWidget {
  const MoreWidget({Key? key}) : super(key: key);

  @override
  MoreScreen createState() => MoreScreen();
}

class MoreScreen extends AcceptableStatefulWidgetState<MoreWidget> {
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
    return button(reaction, context.read<ReactionState>().more);
  }
}

class MoreReaction extends AbstractReaction {
  MoreReaction(super.reaction, super.context, super.post);

  @override
  Future<void> exec() async {
    // TODO: implement exec
  }
}
