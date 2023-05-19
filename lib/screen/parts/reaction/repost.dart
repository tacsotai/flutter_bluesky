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
      create: (context) => RepostState(reaction, context, post),
    );
  }
}

class RepostState extends ValueNotifier<Reaction> {
  final BuildContext context;
  final feed.Post post;
  RepostState(Reaction value, this.context, this.post) : super(value);

  void action() async {
    List<Widget> list = [];
    value.uri != null ? list.add(undo(context)) : list.add(repost(context));
    list.add(quate(context));
    await showModal(list);
    // The notifyListeners notify at chnage the value object.
    value = value.renew;
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
        await plugin.undo(post.uri);
        value.count -= 1;
        value.uri = null;
        Navigator.pop(context);
      },
    );
  }

  ListTile repost(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.repeat),
      title: Text(tr('reaction.repost')),
      onTap: () async {
        Tuple2 res = await plugin.repost(post.author.did, post.uri, post.cid);
        value.count += 1;
        value.uri = res.item2['uri'];
        Navigator.pop(context);
      },
    );
  }

  ListTile quate(BuildContext context) {
    Map record = {
      "embed": {
        "record": {"uri": post.uri, "cid": post.cid}
      }
    };
    return ListTile(
        leading: const Icon(Icons.format_quote),
        title: Text(tr('reaction.repost.quate')),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Post(record: record, popNum: 2)),
          );
        });
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
    accept<RepostState, Reaction>(
      watch: (state) => state.value,
      apply: (value) => reaction = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return withText(reaction, context.read<RepostState>().action);
  }
}
