import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/profile/edit_profile.dart';
import 'package:flutter_bluesky/util/account_util.dart';
import 'package:tuple/tuple.dart';

abstract class Button {
  final State state;
  final ProfileViewBasic actor;

  Button(this.state, this.actor);

  String get text;

  Widget get widget {
    return ElevatedButton(
        onPressed: () => action(),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ))),
        child: Text(text));
  }

  Future<void> action();
}

class FollowButton extends Button {
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
    await plugin.follow(following);
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

class ProfileViewButton extends Button {
  final Button profileEditButton;
  final Button followButton;

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

class ProfileEditButton extends Button {
  ProfileEditButton(super.actor, super.state);

  @override
  String get text => tr("profile.edit");

  @override
  Future<void> action() async {
    Navigator.pushNamed(state.context, EditProfile.screen.route);
  }
}
