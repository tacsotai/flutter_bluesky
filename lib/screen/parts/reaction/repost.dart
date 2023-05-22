// ignore_for_file: use_build_context_synchronously

import 'package:acceptable/acceptable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart' as feed;
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:flutter_bluesky/screen/post.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';
import 'package:tuple/tuple.dart';

class Repost extends StatelessWidget {
  final feed.Post post;
  const Repost(this.post, {super.key});

  Reaction get reaction {
    return Reaction(
        color: Colors.green,
        tooltip: tr("reaction.repost"),
        on: const Icon(Icons.repeat),
        off: const Icon(Icons.repeat),
        count: post.repostCount,
        uri: post.viewer.repost);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: const RepostWidget(),
      create: (context) => ReactionState(reaction, context, post),
    );
  }
}

class RepostWidget extends AcceptableStatefulWidget {
  const RepostWidget({Key? key}) : super(key: key);

  @override
  RepostScreen createState() => RepostScreen();
}

class RepostScreen extends AcceptableStatefulWidgetState<RepostWidget> {
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
    return withText(reaction, context.read<ReactionState>().repost);
  }
}

class RepostReaction extends AbstractReaction {
  RepostReaction(super.reaction, super.context, super.post);

  @override
  Future<void> exec() async {
    List<Widget> list = [];
    reaction.uri != null ? list.add(undo(context)) : list.add(repost(context));
    list.add(quate(context));
    await showModal(list);
  }

  Future<void> showModal(List<Widget> widgets) async {
    await showModalBottomSheet<Widget>(
      context: context,
      builder: (BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, children: widgets);
      },
    );
  }

  ListTile undo(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.repeat),
      title: Text(tr('reaction.repost.undo')),
      onTap: () async {
        await plugin.undo(reaction.uri!);
        reaction.count -= 1;
        reaction.uri = null;
        Navigator.pop(context);
      },
    );
  }

  ListTile repost(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.repeat),
      title: Text(tr('reaction.repost')),
      onTap: () async {
        Tuple2 res = await plugin.repost(post.uri, post.cid);
        reaction.count += 1;
        reaction.uri = res.item2['uri'];
        Navigator.pop(context);
      },
    );
  }

  ListTile quate(BuildContext context) {
    return ListTile(
        leading: const Icon(Icons.format_quote),
        title: Text(tr('reaction.repost.quate')),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Post(postType: PostType.quate, post: post)),
          );
        });
  }
}
