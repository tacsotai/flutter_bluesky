import 'package:acceptable/acceptable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';

class Repost extends StatelessWidget {
  final Post post;
  const Repost(this.post, {super.key});

  Reaction get reaction {
    return Reaction(
        color: Colors.green,
        tooltip: tr("reaction.repost"),
        on: const Icon(Icons.repeat),
        off: const Icon(Icons.repeat),
        count: post.likeCount,
        own: post.viewer.like != null);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: const RepostWidget(),
      create: (context) => RepostState(reaction, context),
    );
  }
}

class RepostState extends ValueNotifier<Reaction> {
  final BuildContext context;
  RepostState(Reaction value, this.context) : super(value);

  void action() async {
    await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: value.off,
              title: Text(value.tooltip),
              onTap: () => Navigator.of(context).pop(0),
            ),
            ListTile(
              leading: const Icon(Icons.format_quote),
              title: Text(tr('reaction.repost.quate')),
              onTap: () => Navigator.of(context).pop(1),
            ),
          ],
        );
      },
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
