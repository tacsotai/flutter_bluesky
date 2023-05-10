import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';

class PostTimeline extends CommonTimeline {
  @override
  Widget build(BuildContext context, Feed feed) {
    Post post = feed.post;
    return Row(
      children: [
        avator(post.author.avatar),
        sizeBox,
        contentFrame(context, feed)
      ],
    );
  }
}
