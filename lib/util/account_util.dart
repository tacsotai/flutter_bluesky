import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/account/account_block.dart';
import 'package:flutter_bluesky/screen/parts/account/account_report.dart';
import 'package:flutter_bluesky/screen/parts/account/account_unblock.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/util/common_util.dart';

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

// Assumption that a login user get profile of actor
// "blocking" is appert in the json if bloced by the login user.
// {
//     "did": "did:plc:ugqaiaq4fw5uzyo75f3icmrx",
//     "handle": "rmbcnl95j9bk443vg.grp.sotai.co",
//     ;
//     "viewer": {
//         "muted": false,
//         "blockedBy": false,
//         "blocking": "at://did:plc:d3tdnbwjkoq6rpaa2vli2adi/app.bsky.graph.block/3kds5x6ogdc2l"
//     },
//     "labels": []
// }
bool blocking(ProfileViewBasic actor) {
  return actor.viewer.blocking != null;
}

// same as blocking
bool following(ProfileViewBasic actor) {
  return actor.viewer.following != null;
}

// same as blocking
bool followedBy(ProfileViewBasic actor) {
  return actor.viewer.followedBy != null;
}

String muteProp(ProfileViewBasic actor) {
  return muted(actor) ? "unmute.account" : "mute.account";
}

String blockProp(ProfileViewBasic actor) {
  return blocking(actor) ? "unblock.account" : "block.account";
}

class AccountUtil {
  static Future<void> mute(State state, ProfileViewDetailed actor) async {
    await plugin.muteActor(actor.did);
    // ignore: invalid_use_of_protected_member
    state.setState(() {
      actor.viewer.muted = true;
    });
    // ignore: use_build_context_synchronously
    await timerDialog(state.context, dialog("mute.account"));
  }

  static Future<void> unmute(State state, ProfileViewDetailed actor) async {
    await plugin.unmuteActor(actor.did);
    // ignore: invalid_use_of_protected_member
    state.setState(() {
      actor.viewer.muted = false;
    });
    // ignore: use_build_context_synchronously
    await timerDialog(state.context, dialog("unmute.account"));
  }

  static Future<void> block(State state, ProfileViewDetailed actor) async {
    AccountBlock modal = AccountBlock(actor: actor);
    await showModal(state.context, modal);
    if (modal.button.actionStatus == ActionStatus.completed) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
      // ignore: use_build_context_synchronously
      await timerDialog(state.context, dialog("block.account"));
    }
    // TODO error case
  }

  static Future<void> unblock(State state, ProfileViewDetailed actor) async {
    AccountUnblock modal = AccountUnblock(actor: actor);
    await showModal(state.context, modal);
    if (modal.button.actionStatus == ActionStatus.completed) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
      // ignore: use_build_context_synchronously
      await timerDialog(state.context, dialog("unblock.account"));
    }
    // TODO error case
  }

  static Future<void> report(State state, ProfileViewDetailed actor) async {
    AccountReport modal = AccountReport(actor: actor);
    await showModal(state.context, modal);
    if (modal.button.actionStatus == ActionStatus.completed) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
      // ignore: use_build_context_synchronously
      await timerDialog(state.context, messageDialog("report.thank"));
    }
    // TODO error case
  }
}
