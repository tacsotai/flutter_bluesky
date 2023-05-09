import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

class ReasonTimeline extends CommonTimeline {
  @override
  Widget? build(BuildContext context, Feed feed) {
    if (feed.reply == null) {
      return null;
    }
    return const Text("Reason");
  }
}
