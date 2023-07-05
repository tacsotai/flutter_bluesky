import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/settings/account_setting.dart';

class Settings extends StatelessWidget {
  static Screen screen = Screen(Settings, const Icon(Icons.settings));
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(tr('Settings')),
        ),
        body: const Column(children: [
          AccountSetting(),
        ]));
  }
}
