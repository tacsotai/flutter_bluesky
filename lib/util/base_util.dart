import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';

void pushBase(BuildContext context, {int selectedIndex = 0}) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    settings: RouteSettings(name: Base.route),
    builder: (context) => Base(selectedIndex: selectedIndex),
  ));
}
