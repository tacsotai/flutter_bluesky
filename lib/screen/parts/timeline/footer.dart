import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart' as feed;
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:flutter_bluesky/screen/parts/reaction/like.dart';
import 'package:flutter_bluesky/screen/parts/reaction/more.dart';
import 'package:flutter_bluesky/screen/parts/reaction/reply.dart';
import 'package:flutter_bluesky/screen/parts/reaction/repost.dart';

class Footer extends StatelessWidget {
  final feed.Post post;
  const Footer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Reply(post),
        Repost(post),
        Like(post),
        More(post),
      ],
    );
  }
}

Widget withText(Reaction reaction, Function() func) {
  return Row(
    children: [
      button(reaction, func),
      Text(
        reaction.count.toString(),
        style: TextStyle(color: reaction.own ? reaction.color : Colors.grey),
      )
    ],
  );
}

Widget button(Reaction reaction, Function() func) {
  return IconTheme(
    data: IconThemeData(color: reaction.own ? reaction.color : Colors.grey),
    child: Row(
      children: [
        IconButton(
          tooltip: reaction.tooltip,
          icon: reaction.own ? reaction.on : reaction.off,
          onPressed: func,
        )
      ],
    ),
  );
}
