import 'package:acceptable/acceptable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';

class Reply extends StatelessWidget {
  final Post post;
  const Reply(this.post, {super.key});

  Reaction get reaction {
    return Reaction(
        color: Colors.grey,
        tooltip: tr("reaction.reply"),
        on: const Icon(Icons.chat_bubble_outline),
        off: const Icon(Icons.chat_bubble_outline),
        count: post.likeCount,
        uri: null);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: const ReplyWidget(),
      create: (context) => ReactionState(reaction),
    );
  }
}

class ReplyWidget extends AcceptableStatefulWidget {
  const ReplyWidget({Key? key}) : super(key: key);

  @override
  ReplyScreen createState() => ReplyScreen();
}

class ReplyScreen extends AcceptableStatefulWidgetState<ReplyWidget> {
  late Reaction reaction;
  @override
  void acceptProviders(Accept accept) {
    accept<ReactionState, Reaction>(
      watch: (state) => state.value,
      apply: (value) => reaction = value,
      // perform: (value) {
      //   if (value == 10) {
      //     showDialog(
      //       context: context,
      //       builder: (context) => AlertDialog(
      //         content: Text('$value'),
      //       ),
      //     );
      //   }
      // },
    );
  }

  @override
  Widget build(BuildContext context) {
    return withText(reaction, context.read<ReactionState>().action);
  }
}
