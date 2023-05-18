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


  Widget interest(
      BuildContext context, String tooltip, IconData data, int count) {
    return Row(
      children: [
        iconTheme(context, tooltip, data),
        Text(
          count.toString(),
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget iconTheme(BuildContext context, String tooltip, IconData data) {
    return IconTheme(
      data: const IconThemeData(color: Colors.grey),
      child: Row(
        children: [
          IconButton(
            tooltip: tooltip,
            icon: Icon(data),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
