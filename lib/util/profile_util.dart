import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/button/button_manager.dart';
import 'package:flutter_bluesky/screen/parts/image/banner.dart' as prof;
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

ActorWidget? actorWidget;

class ProfileUtil {
  final State state;
  final ProfileViewDetailed actor;

  ProfileUtil(this.state, this.actor);

  static ProfileUtil getUtil(State state, ProfileViewDetailed actor) {
    return ProfileUtil(state, actor);
  }

  Widget get header {
    return Column(
      children: [
        bannerAvatar,
        actorWidget!.info(actor),
        const Divider(height: 0.5),
      ],
    );
  }

  Widget get bannerAvatar {
    Widget button = buttonManager!.profileViewButton(state, actor).widget;
    return Stack(alignment: AlignmentDirectional.bottomStart, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        banner,
        const Divider(height: 0.5),
        padding(button, top: 5, bottom: 5)
      ]),
      padding(profAvatar)
    ]);
  }

  Widget get banner {
    return prof.Banner(state.context).net(actor).widget;
  }

  Widget get profAvatar {
    return Avatar(state.context, radius: 45).net(actor).profile;
  }
}

abstract class ActorWidget {
  Widget info(ProfileViewDetailed actor);
  Widget counts(ProfileViewDetailed actor);
}

class DefaultActorWidget extends ActorWidget {
  @override
  Widget info(ProfileViewDetailed actor) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayName(actor, fontSize: 28),
              handle(actor),
              counts(actor),
              description(actor),
            ],
          ),
        ));
  }

  @override
  Widget counts(ProfileViewDetailed actor) {
    return Row(
      children: [
        count(actor.followersCount, 'followers'),
        sizeBox,
        count(actor.followsCount, 'following'),
        sizeBox,
        count(actor.postsCount, 'posts'),
      ],
    );
  }
}
