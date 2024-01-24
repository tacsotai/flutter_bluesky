import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  static const route = '/error';
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr("error.network"))),
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(tr("error.network.message1")),
        Text(tr("error.network.message2")),
        Text(tr("error.network.message3")),
      ])),
    );
  }
}
