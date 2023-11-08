import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/settings/setting_util.dart';
import 'package:flutter_bluesky/util/account_util.dart';
import 'package:flutter_bluesky/util/common_util.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';

Color color = Colors.red.shade400;

class AccountSetting extends StatelessWidget {
  const AccountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return widget(context, tr("account"), [
      accountItem(context, plugin.api.session.actor as ProfileViewBasic),
      deleteAccout(context, plugin.api.session.actor as ProfileViewBasic)
      // addAccountItem(context),
    ]);
  }

  // TODO get from keeping session.
  Widget accountItem(BuildContext context, ProfileViewBasic author) {
    Widget? logout;
    if (author.did == plugin.api.session.did) {
      logout = textItem(tr("logout"));
    }

    Widget left = Row(
      children: [
        Avatar(context, radius: 20).net(author).profile,
        sizeBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textItem(getAccount(plugin.api.session.handle!)),
            textItem(plugin.api.session.email!),
          ],
        ),
      ],
    );
    Widget right = InkWell(
        child: logout,
        onTap: () async {
          await plugin.logout();
          // ignore: use_build_context_synchronously
          inkwell(context, transfer: const LoginScreen());
        });
    return lr(left, right, const Tuple2(10, 4));
  }

  Widget deleteAccout(BuildContext context, ProfileViewBasic author) {
    return Row(children: [
      circleItem(context, 20, Icons.delete, color: color),
      sizeBox,
      InkWell(
        child: textItem('${tr("account.delete")}...', color: color),
        onTap: () async {
          await showModal(context, const AccountDelete());
        },
      ),
    ]);
  }
}

class AccountDelete extends StatefulWidget {
  const AccountDelete({super.key});

  @override
  AccountDeleteScreen createState() => AccountDeleteScreen();
}

class AccountDeleteScreen extends State<AccountDelete> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool hasApiError = false;
  String _password = "";
  String _token = "";

  bool isInit = true;
  List<Widget> initItems = [];

  @override
  Widget build(BuildContext context) {
    Widget modal;
    if (isInit) {
      makeInitItems();
      modal = sendMail();
      isInit = false;
    } else {
      modal = confirmation();
    }
    return modal;
  }

  void makeInitItems() {
    initItems.add(textItem(tr("account.delete"),
        fontSize: 24, fontWeight: FontWeight.bold));
    initItems.add(sizeBox);
    initItems.add(textItem('"${getAccount(plugin.api.session.handle!)}"',
        fontSize: 24, fontWeight: FontWeight.bold));
    initItems.add(sizeBox);
    initItems.add(sizeBox);
    CancelButton cancelButton = CancelButton(this);
    cancelButton.height = 60;
    cancelButton.left = 20;
    cancelButton.top = 0;
    cancelButton.right = 20;
    cancelButton.bottom = 10;
    initItems.add(SizedBox(width: double.infinity, child: cancelButton.widget));
  }

  Widget sendMail() {
    List<Widget> items = [];
    items.addAll(initItems);
    SendEmailButton sendEmailButton = SendEmailButton(this);
    sendEmailButton.backgroundColor =
        MaterialStateProperty.all(Theme.of(context).primaryColor);
    sendEmailButton.color = Colors.white;
    sendEmailButton.height = 60;
    sendEmailButton.left = 20;
    sendEmailButton.top = 10;
    sendEmailButton.right = 20;
    sendEmailButton.bottom = 0;
    items.insertAll(3, [
      textItem(tr("account.delete.confirmation")),
      sizeBox,
      SizedBox(width: double.infinity, child: sendEmailButton.widget)
    ]);
    return padding20(Column(children: items));
  }

  Widget confirmation() {
    List<Widget> items = [];
    items.addAll(initItems);
    items.insertAll(3, [
      textItem(tr("account.delete.code.password")),
      sizeBox,
      textFrom("confirmation.code.hint"),
      sizeBox,
      textFrom("password.hint"),
      sizeBox,
      SizedBox(width: double.infinity, child: submit)
    ]);
    return Form(key: _formKey, child: (padding20(Column(children: items))));
  }

  Widget textFrom(String labelProp) {
    bool isPassword = labelProp == "password.hint";
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: tr(labelProp),
      ),
      onSaved: (text) {
        setState(() {
          if (isPassword) {
            _password = text!;
          } else {
            _token = text!;
          }
        });
      },
      validator: (text) {
        if (text!.isEmpty) {
          return tr("required");
        }
        if (hasApiError) {
          return tr("validation.error.token.or.password");
        }
        return null;
      },
    );
  }

  Widget get submit {
    return ElevatedButton(
        onPressed: _submit,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))),
        child: Text(tr("account.delete")));
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save(); // call onSaved of Field
      Tuple2 res = await plugin.deleteAccount(
          plugin.api.session.did!, _password, _token);
      if (res.item1 == 200) {
        await plugin.logout();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
      } else {
        hasApiError = true;
        _formKey.currentState!.validate();
        hasApiError = false;
      }
    }
  }
}

class SendEmailButton extends SizedButton {
  SendEmailButton(super.state);

  @override
  Future<void> action() async {
    await plugin.requestAccountDelete();
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  @override
  String get text => tr("send.email");
}
