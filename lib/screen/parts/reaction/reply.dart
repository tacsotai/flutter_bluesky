import 'package:acceptable/acceptable.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';

class Reply extends ReactionBody {
  Reply()
      : super(
          color: Colors.grey,
          tooltip: tr("reaction.reply"),
          on: const Icon(Icons.chat_bubble_outline),
          off: const Icon(Icons.chat_bubble_outline),
        );
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
    return widget(context, reaction);
  }
}
