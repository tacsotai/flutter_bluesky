import 'package:flutter/material.dart';

Widget get sizeBox {
  return const SizedBox(
    height: 10,
    width: 5,
  );
}

Widget listsBody(List<Widget> widgets) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: widgets,
  );
}
