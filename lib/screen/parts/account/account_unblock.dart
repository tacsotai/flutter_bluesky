import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';
import 'package:tuple/tuple.dart';

// ignore: must_be_immutable
class AccountUnblock extends StatefulWidget {
  final ProfileViewDetailed actor;
  late ModalButton button;
  AccountUnblock({super.key, required this.actor});

  @override
  AccountUnblockScreen createState() => AccountUnblockScreen();
}

class AccountUnblockScreen extends State<AccountUnblock> {
  Widget header = padding20(
      Text(tr("unblock.account"), style: const TextStyle(fontSize: 24)));
  Widget content = padding20(Text(tr("unblock.account.message"),
      style: const TextStyle(color: Colors.black87)));

  @override
  Widget build(BuildContext context) {
    widget.button = BlockConfirmButton(this, widget.actor);
    return Column(children: [
      header,
      content,
      sizeBox,
      sizeBox,
      sizeBox,
      widget.button.widget
    ]);
  }
}

class BlockConfirmButton extends ConfirmButton {
  final ProfileViewDetailed actor;

  BlockConfirmButton(super.state, this.actor);

  @override
  Future<void> action() async {
    Tuple2 res = await plugin.unblock(actor.viewer.blocking!);
    setActionStatus(res.item1);
    if (actionStatus == ActionStatus.completed) {
      actor.viewer.blocking = null;
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(state.context);
  }
}
