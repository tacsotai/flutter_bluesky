import 'package:flutter/material.dart';

Widget get sizeBox {
  return const SizedBox(
    height: 10,
    width: 5,
  );
}

Widget padding(
  Widget widget, {
  double? all,
  double? left = 0,
  double? top = 0,
  double? right = 0,
  double? bottom = 0,
}) {
  if (all != null) {
    return Padding(padding: EdgeInsets.all(all), child: widget);
  } else {
    return Padding(
        padding: EdgeInsets.fromLTRB(left!, top!, right!, bottom!),
        child: widget);
  }
}

Widget padding10(
  Widget widget, {
  double left = 10,
  double top = 10,
  double right = 10,
  double bottom = 10,
}) {
  return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom), child: widget);
}

Widget padding2(
  Widget widget, {
  double ltrb = 2,
}) {
  return Padding(padding: EdgeInsets.all(ltrb), child: widget);
}

Widget padding20(
  Widget widget, {
  double left = 20,
  double top = 20,
  double right = 20,
  double bottom = 20,
}) {
  return padding10(widget, left: left, top: top, right: right, bottom: bottom);
}

Widget listsBody(List<Widget> widgets) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: widgets,
  );
}
