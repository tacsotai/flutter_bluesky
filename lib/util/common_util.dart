import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget textItem(
  String content, {
  Color? color,
  double? fontSize = 16,
  FontWeight? fontWeight = FontWeight.normal,
}) {
  return Text(
    content,
    style: TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
  );
}

Widget circleItem(BuildContext context, double radius, IconData data,
    {Color? color}) {
  return CircleAvatar(
      radius: radius,
      // backgroundColor: ColorScheme.,
      foregroundColor: color ?? Theme.of(context).colorScheme.primary,
      child: Icon(data, size: 50 * (radius / 35)));
}

void inkwell(BuildContext context, {Widget? transfer, String? link}) async {
  if (transfer != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => transfer),
    );
  }
  if (link != null) {
    Uri uri = Uri.parse(link);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}


Future<void> showModal(BuildContext context, Widget widget) async {
  await showModalBottomSheet<Widget>(
    context: context,
    builder: (BuildContext context) {
      return widget;
    },
  );
}
