import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

bool isLoginUser(ProfileViewBasic actor) {
  return actor.did == plugin.api.session.actor!.did;
}

bool _useDomain = true;

void notShowDomain() {
  _useDomain = false;
}

// see Header
String getAccount(String handle) {
  if (_useDomain) {
    return handle;
  }
  return withoutDomain(handle);
}

bool muted(ProfileViewBasic actor) {
  return actor.viewer.muted!;
}

bool blockedBy(ProfileViewBasic actor) {
  return actor.viewer.blockedBy!;
}

bool blocking(ProfileViewBasic actor) {
  return actor.viewer.blocking != null && actor.viewer.blocking!.isNotEmpty;
}

bool following(ProfileViewBasic actor) {
  return actor.viewer.following != null && actor.viewer.following!.isNotEmpty;
}

bool followedBy(ProfileViewBasic actor) {
  return actor.viewer.followedBy != null && actor.viewer.followedBy!.isNotEmpty;
}

String muteProp(ProfileViewBasic actor) {
  return muted(actor) ? "unmute.account" : "mute.account";
}

String blockProp(ProfileViewBasic actor) {
  return blocking(actor) ? "unblock.account" : "block.account";
}
