import 'package:flutter_bluesky/data/model/actor.dart';
import 'package:flutter_bluesky/data/model/viewer.dart';

class Post {
  final String uri;
  final String cid;
  final Actor author;
  final Map record;
  final int replyCount;
  final int repostCount;
  final int likeCount;
  final DateTime indexedAt;
  final Viewer viewer;

  Post({
    required this.uri,
    required this.cid,
    required this.author,
    required this.record,
    required this.replyCount,
    required this.repostCount,
    required this.likeCount,
    required this.indexedAt,
    required this.viewer,
  });
}
