import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

// This class is used as Repost header.
// Ex. 'Reposted by someone'
class ReasonTimeline extends CommonTimeline {
  @override
  Widget? build(BuildContext context, Feed feed) {
    if (feed.reason == null) {
      return null;
    }
    return Row(
      children: [
        const SizedBox(width: 60),
        const Icon(Icons.repeat, color: Colors.grey, size: 14),
        sizeBox,
        Text('Reposted by ${feed.reason!.by.displayName}',
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold))
      ],
    );
  }
}
