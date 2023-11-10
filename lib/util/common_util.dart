import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

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

InputDecoration decoration(String prop) {
  return InputDecoration(
    border: const OutlineInputBorder(),
    labelText: tr(prop),
  );
}

Future<void> showModal(BuildContext context, Widget widget) async {
  await showModalBottomSheet<Widget>(
    context: context,
    builder: (BuildContext context) {
      return widget;
    },
  );
}

Future<void> timerDialog(State state, AlertDialog dialog) async {
  const displayTime = Duration(seconds: 2);
  try {
    await showDialog(
      context: state.context,
      barrierColor: Colors.white10,
      builder: (context) {
        return dialog;
      },
    ).timeout(displayTime);
  } on TimeoutException {
    // ignore: use_build_context_synchronously
    Navigator.of(state.context).pop();
  }
}

AlertDialog dialog(String prop) {
  return alertDialog(prop);
}

AlertDialog messageDialog(String prop) {
  return alertDialog(
    prop,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    titlePadding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
    textAlign: TextAlign.left,
  );
}

AlertDialog alertDialog(String prop,
    {ShapeBorder? shape,
    EdgeInsets? titlePadding = const EdgeInsets.all(10),
    textAlign = TextAlign.center}) {
  return AlertDialog(
    shape: shape,
    titlePadding: titlePadding,
    alignment: Alignment.topCenter,
    title: Text(
      tr(prop),
      textAlign: textAlign,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    ),
  );
}
