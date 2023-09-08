import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart' as feed;
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
