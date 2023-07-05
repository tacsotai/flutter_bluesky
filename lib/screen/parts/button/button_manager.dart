import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';

ButtonManager? buttonManager;

/// This class is little bit complecated to pluggable buttons.
/// 1. Set the class Object to [buttonManager].
/// 2. A program call buttonManager!.setActor() to use the buttons.
abstract class ButtonManager {
  // the button which on profile_view
  ProfileButton profileViewButton(State state, ProfileViewDetailed actor);

  // the button which on profile_view or timeline, search, and notifications.
  /// [actor].runtimeType may [ProfileViewDetailed]
  ProfileButton followButton(State state, ProfileViewBasic actor);
}

class DefaultButtonManager extends ButtonManager {
  @override
  ProfileButton profileViewButton(State state, ProfileViewDetailed actor) {
    return ProfileViewButton(state, actor);
  }

  @override
  ProfileButton followButton(State state, ProfileViewBasic actor) {
    return FollowButton(state, actor);
  }
}
