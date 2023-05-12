import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common_post.dart';

abstract class CommonTimeline {
  Widget? build(BuildContext context, Feed feed);

  Widget contentFrame(BuildContext context, Feed feed) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content(context, feed),
            )));
  }

  List<Widget> content(BuildContext context, Feed feed) {
    return postContent(context, feed.post);
  }
}
