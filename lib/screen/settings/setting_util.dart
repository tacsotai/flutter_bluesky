import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';

Widget widget(BuildContext context, String headline, List<Widget> items) {
  List<Widget> widgets = paddings(context, items);
  widgets.insert(0, header(context, headline));
  List<Widget> list = [];
  for (var widget in widgets) {
    list.add(widget);
  }
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: list);
}

Widget header(BuildContext context, String headline,
    {Color? color = Colors.black}) {
  return Container(
      width: double.infinity,
      color: Colors.black12,
      child: padding10(Text(
        headline,
        style: TextStyle(fontSize: 18, color: color),
      )));
}

List<Widget> paddings(BuildContext context, List<Widget> items) {
  List<Widget> widgets = [];
  for (var item in items) {
    widgets.add(padding10(item, left: 20));
    widgets.add(const Divider(height: 0.5));
  }
  return widgets;
}
