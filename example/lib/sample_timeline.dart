import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/timeline/post_tl.dart';

class SamplePostTimeline extends PostTL {
  @override
  Widget build() {
    post.record.text = 'pluggable ${post.record.text}';
    return postTL(post);
  }
}
