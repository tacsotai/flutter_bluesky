import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';

class AccountBlock extends StatefulWidget {
  final ProfileViewDetailed actor;
  const AccountBlock({super.key, required this.actor});

  @override
  AccountBlockScreen createState() => AccountBlockScreen();
}

class AccountBlockScreen extends State<AccountBlock> {
  Widget header = padding20(
      Text(tr("block.account"), style: const TextStyle(fontSize: 24)));
  Widget content = padding20(Text(tr("block.account.message"),
      style: const TextStyle(color: Colors.black87)));

  @override
  Widget build(BuildContext context) {
    ModalButton button = BlockConfirmButton(this, widget.actor);
    return Column(
        children: [header, content, sizeBox, sizeBox, sizeBox, button.widget]);
  }
}

class BlockConfirmButton extends ConfirmButton {
  final ProfileViewDetailed actor;

  BlockConfirmButton(super.state, this.actor);

  @override
  Future<void> action() async {
    await plugin.block(actor.did);
    // ignore: use_build_context_synchronously
    Navigator.pop(state.context);
  }
}
