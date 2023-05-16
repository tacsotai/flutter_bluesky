import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/reaction.dart';
import 'package:flutter_bluesky/screen/parts/reaction/like.dart';
import 'package:provider/provider.dart';

class Footer extends StatelessWidget {
  final Post post;
  const Footer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        reply(context, post),
        repost(context, post),
        like(context, post),
        more(context, post),
      ],
    );
  }

  Widget reply(BuildContext context, Post post) {
    return interest(
        context, 'Reply', Icons.chat_bubble_outline, post.replyCount);
  }

  Widget repost(BuildContext context, Post post) {
    return interest(context, 'Repost', Icons.repeat, post.repostCount);
  }

  Widget like(BuildContext context, Post post) {
    Reaction reaction = Reaction(
      body: Like(),
      withCount: true,
      count: post.likeCount,
      own: post.viewer.like != null,
    );
    return ChangeNotifierProvider(
      child: const LikeWidget(),
      create: (context) => ReactionState(reaction),
    );
  }

  Widget more(BuildContext context, Post post) {
    return iconTheme(context, 'Like', Icons.more_horiz);
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
