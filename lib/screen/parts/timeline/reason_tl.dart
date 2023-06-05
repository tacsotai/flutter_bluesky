import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';

// This class is used as Repost header.
// Ex. 'Reposted by someone'
abstract class ReasonTL {
  late ProfileViewBasic actor;
  void setActor(ProfileViewBasic actor) {
    this.actor = actor;
  }

  Widget? build(BuildContext context);
}

class ReasonTimeline extends ReasonTL {
  @override
  Widget? build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 60),
        const Icon(Icons.repeat, color: Colors.grey, size: 14),
        sizeBox,
        Text(tr('reposted.by', args: [actor.displayName ?? actor.handle]),
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold))
      ],
    );
  }
}
