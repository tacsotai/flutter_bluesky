import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/profile/edit_profile.dart';
import 'package:flutter_bluesky/util/account_util.dart';
import 'package:flutter_bluesky/util/common_util.dart';
import 'package:tuple/tuple.dart';

abstract class Button {
  MaterialStateProperty<Color?>? backgroundColor;
  Color? color;
  double? fontSize = 14;
  FontWeight? fontWeight = FontWeight.normal;

  final State state;
  Button(this.state);

  Widget get widget {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: backgroundColor,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
        child: textItem(text,
            color: color, fontSize: fontSize, fontWeight: fontWeight));
  }

  String get text;

  VoidCallback? get onPressed {
    return () => action();
  }

  Future<void> action();
}

abstract class ProfileButton extends Button {
  final ProfileViewBasic actor;

  ProfileButton(super.state, this.actor);
}

class FollowButton extends ProfileButton {
  String following;
  List<ProfileViewBasic> follwers = [];
  FollowButton(super.state, super.actor)
      : following = actor.viewer.following ?? "";

  bool get isFollowing {
    return following.contains(plugin.api.session.did!);
  }

  @override
  Future<void> action() async {
    isFollowing ? unfollow() : follow();
  }

  Future<void> follow() async {
    Tuple2 res = await plugin.follow(actor.did);
    actor.viewer.following = res.item2["uri"];
    add(1);
  }

  Future<void> unfollow() async {
    await plugin.unfollow(following);
    actor.viewer.following = "";
    add(-1);
  }

  void add(int count) {
    if (actor.runtimeType == ProfileViewDetailed) {
      (actor as ProfileViewDetailed).followersCount += count;
    }
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  @override
  String get text => isFollowing ? tr("following") : tr("follow");
}

class ProfileViewButton extends ProfileButton {
  final ProfileButton profileEditButton;
  final ProfileButton followButton;

  ProfileViewButton(super.state, super.actor)
      : profileEditButton = ProfileEditButton(state, actor),
        followButton = FollowButton(state, actor);

  @override
  Widget get widget {
    if (isLoginUser(actor)) {
      return profileEditButton.widget;
    } else {
      return followButton.widget;
    }
  }

  @override
  String get text =>
      isLoginUser(actor) ? profileEditButton.text : followButton.text;

  @override
  Future<void> action() async {
    isLoginUser(actor)
        ? await profileEditButton.action()
        : await followButton.action();
  }
}

class ProfileEditButton extends ProfileButton {
  ProfileEditButton(super.actor, super.state);

  @override
  String get text => tr("profile.edit");

  @override
  Future<void> action() async {
    Navigator.pushNamed(state.context, EditProfile.screen.route);
  }
}
