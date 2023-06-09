import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';
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

Widget textFrom(String labelText, Map values, String key, State state,
    {FormFieldValidator<String>? validator}) {
  return TextFormField(
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: labelText,
    ),
    onSaved: (text) {
      // ignore: invalid_use_of_protected_member
      state.setState(() {
        values[key] = text!;
      });
    },
    validator: validator,
  );
}

class CancelButton extends Button {
  CancelButton(super.state);

  @override
  Future<void> action() async {
    Navigator.pop(state.context);
  }

  @override
  String get text => tr("submit.cancel");
}
