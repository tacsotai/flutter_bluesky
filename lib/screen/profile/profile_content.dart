import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/button/button_manager.dart';
import 'package:flutter_bluesky/screen/parts/image/banner.dart' as prof;
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/util/account_util.dart';

ProfileContent? profileContent;

class ProfileContent {
  late State state;
  late ProfileViewDetailed actor;

  Widget get header {
    return Column(
      children: [
        bannerAvatar,
        info(actor),
        const Divider(height: 0.5),
      ],
    );
  }

  Widget get bannerAvatar {
    ProfileButton button = buttonManager!.profileViewButton(state, actor);
    return Stack(alignment: AlignmentDirectional.bottomStart, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        banner,
        const Divider(height: 0.5),
        padding(profileButtons(button), top: 5, bottom: 5)
      ]),
      padding(profAvatar)
    ]);
  }

  Widget profileButtons(ProfileButton button) {
    List<Widget> buttons = [button.widget];
    if (!isLoginUser(button.actor)) {
      buttons.add(button.menu(profileItems));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: buttons,
    );
  }

  List<PopupMenuItem> get profileItems {
    return [
      PopupMenuItem(
        child: Text(tr("menu.block.account")),
        onTap: () async => await plugin.block(actor.did),
      ),
    ];
  }

  Widget get banner {
    return prof.Banner(state.context).net(actor).widget;
  }

  Widget get profAvatar {
    return Avatar(state.context, radius: 45).net(actor).profile;
  }

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
