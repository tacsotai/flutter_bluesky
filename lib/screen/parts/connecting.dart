import 'package:flutter/material.dart';

class Connecting {
  final BuildContext context;
  Connecting(this.context);

  List<Widget> listview() {
    return [
      const Spacer(),
      const Text('Connecting...'),
      const Spacer(),
    ];
  }
}
