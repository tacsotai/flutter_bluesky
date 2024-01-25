import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/actors.dart';
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
  Map<String, List<String>> specialActors = {};

  Widget get header {
    return Column(
      children: [
        bannerAvatar,
        info,
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
        padding10(profileButtons(button), top: 5, bottom: 5)
      ]),
      padding10(profAvatar)
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
    if (!isLoginUser(actor)) {
      return [
        PopupMenuItem(
          child: Text(tr(muteProp(actor))),
          onTap: () async => {
            muted(actor)
                ? await AccountUtil.unmute(state, actor)
                : await AccountUtil.mute(state, actor)
          },
        ),
        PopupMenuItem(
          child: Text(tr(blockProp(actor))),
          onTap: () async => {
            blocking(actor)
                ? await AccountUtil.unblock(state, actor)
                : await AccountUtil.block(state, actor)
          },
        ),
        PopupMenuItem(
          child: Text(tr("report.account")),
          onTap: () async => await AccountUtil.report(state, actor),
        ),
      ];
    }
    return []; // The case of actor is Login user.
  }

  Widget get banner {
    return prof.Banner(state.context).net(actor).widget;
  }

  Widget get profAvatar {
    return Avatar(state.context, radius: largeRadius).net(actor).profile;
  }

  Widget get info {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayName(actor, fontSize: 28),
              handle(actor),
              counts,
              description(actor, state.context),
            ],
          ),
        ));
  }

  Widget get counts {
    return Row(
      children: [
        link(actor.followersCount, 'followers'),
        sizeBox,
        link(actor.followsCount, 'following'),
        sizeBox,
        count(actor.postsCount, 'posts'),
      ],
    );
  }

  Widget count(int count, String postfix) {
    return Row(children: [
      bold(count),
      Text(tr(postfix), style: const TextStyle(color: Colors.grey)),
    ]);
  }

  Widget link(int count, String postfix) {
    return Row(children: [
      bold(count),
      InkWell(
        child: Text(tr(postfix), style: const TextStyle(color: Colors.blue)),
        onTap: () {
          Navigator.push(
            state.context,
            MaterialPageRoute(
                builder: (context) => Actors(actor: actor.did, prop: postfix)),
          );
        },
      )
    ]);
  }
}
