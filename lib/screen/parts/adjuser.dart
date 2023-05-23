import 'package:flutter/material.dart';

Widget get sizeBox {
  return const SizedBox(
    height: 10,
    width: 5,
  );
}

Widget padding(
  Widget widget, {
  double left = 10,
  double top = 10,
  double right = 10,
  double bottom = 10,
}) {
  return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom), child: widget);
}

Widget listsBody(List<Widget> widgets) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: widgets,
  );
}
