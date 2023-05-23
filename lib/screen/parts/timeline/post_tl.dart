import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

abstract class PostTL {
  late Post post;
  void setPost(Post post) {
    this.post = post;
  }

  Widget build(BuildContext context);
}

class PostTimeline extends PostTL {
  @override
  Widget build(BuildContext context) {
    return postTL(context, post);
  }
}
