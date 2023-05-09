import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/timeline/post_tl.dart';
import 'package:flutter_bluesky/screen/parts/timeline/reason_tl.dart';
import 'package:flutter_bluesky/screen/parts/timeline/reply_tl.dart';

// There are 3 pieces at Feed : post, reply?, reason?

class Timeline {
  final BuildContext context;
  final Feed feed;
  Timeline(this.context, this.feed);

  Widget build() {
    List<Widget> widgets = [];
    append(widgets, PostTimeline(), 'post');
    append(widgets, ReplyTimeline(), 'reply');
    append(widgets, ReasonTimeline(), 'reason');
    return Column(
      children: widgets,
    );
  }

  void append(List<Widget> widgets, CommonTimeline timeline, String piece) {
    CommonTimeline? tl = pluggableTimelines[piece];
    if (tl != null) {
      Widget? pluggable = tl.build(context, feed);
      if (pluggable != null) {
        widgets.add(pluggable);
      }
    } else {
      Widget? widget = timeline.build(context, feed);
      if (widget != null) {
        widgets.add(widget);
      }
    }
  }
}
