import 'package:acceptable/acceptable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/post/post_delete.dart';
import 'package:flutter_bluesky/screen/parts/post/post_report.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:flutter_bluesky/util/common_util.dart';
import 'package:flutter_bluesky/util/reaction_util.dart';
import 'package:provider/provider.dart';

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
        uri: post.viewer!.like);
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
    await popupMenu(context, [
      // PopupMenuItem(
      //   child: Text(tr("menu.translate")),
      //   onTap: () => debugPrint("menu.translate"),
      // ),
      PopupMenuItem(
        child: Text(tr("copy.text")),
        onTap: () async => await saveToclipboard(post),
      ),
      // PopupMenuItem(
      //   child: Text(tr("menu.share")),
      //   onTap: () => debugPrint("menu.share"),
      // ),
      // TODO #165
      // PopupMenuItem(
      //   child: Text(tr("menu.mute.thread")),
      //   onTap: () => debugPrint("menu.mute.thread"),
      // ),
      PopupMenuItem(
        child: Text(tr("report.post")),
        onTap: () async => await showModal(context, PostReport(post: post)),
      ),
      // if the post user is the login user, delete post
      PopupMenuItem(
        child: Text(tr("delete.post")),
        onTap: () async => await showModal(context, PostDelete(post: post)),
      ),
    ]);
  }
}
