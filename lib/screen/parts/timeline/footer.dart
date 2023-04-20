import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';

Widget reply(BuildContext context, Post post) {
  return interest(context, 'Reply', Icons.chat_bubble_outline, post.replyCount);
}

Widget repost(BuildContext context, Post post) {
  return interest(context, 'Repost', Icons.repeat, post.repostCount);
}

Widget like(BuildContext context, Post post) {
  return interest(context, 'Like', Icons.favorite_outline, post.likeCount);
}

Widget interest(
    BuildContext context, String tooltip, IconData data, int count) {
  return Row(
    children: [
      IconTheme(
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
      ),
      Text(
        count.toString(),
        style: const TextStyle(color: Colors.grey),
      )
    ],
  );
}
