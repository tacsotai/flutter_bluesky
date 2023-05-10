import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';

class SamplePostTimeline extends CommonTimeline {
  @override
  Widget build(BuildContext context, Feed feed) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        avator(feed.post.author.avatar),
        sizeBox,
        contentFrame(context, feed)
      ],
    );
  }

  @override
  Widget body(BuildContext context, Post post) {
    return Row(
      children: [
        Expanded(
            child: Text(
          'pluggable ${post.record.text}',
        )),
      ],
    );
  }
}
