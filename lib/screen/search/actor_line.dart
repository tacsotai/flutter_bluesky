import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';
import 'package:flutter_bluesky/screen/parts/button/button_manager.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/profile.dart';
import 'package:tuple/tuple.dart';

ActorContent? customActorContent;

class ActorLine extends StatefulWidget {
  final ProfileView actor;
  const ActorLine({Key? key, required this.actor}) : super(key: key);
  @override
  ActorLineScreen createState() => ActorLineScreen();
}

class ActorLineScreen extends State<ActorLine> {
  @override
  Widget build(BuildContext context) {
    return padding10(paddingLR([
      Avatar(context).net(widget.actor).profile
    ], [
      content,
    ]));
  }

  Widget get content {
    ActorContent ac = customActorContent ?? ActorContent();
    return ac.build(this, widget.actor);
  }
}

class ActorContent {
  Widget build(State state, ProfileView actor) {
    Widget left = displayNameHandle(actor);
    FollowButton button =
        buttonManager!.followButton(state, actor) as FollowButton;
    Widget right = button.widget;
    Widget transfer = Profile(actor: actor.did);
    return inkWell(state, actor, left, right, transfer);
  }

  Widget inkWell(State state, ProfileView actor, Widget left, Widget right,
      Widget transfer) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lr(left, right, const Tuple2(5, 4)),
          description(actor),
        ],
      ),
      onTap: () async {
        Navigator.push(
          state.context,
          MaterialPageRoute(builder: (context) => transfer),
        );
      },
    );
  }
}
