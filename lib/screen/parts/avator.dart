import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';

Widget avator(String? url, {double radius = 35}) {
  return padding(
      CircleAvatar(
        radius: radius,
        backgroundImage: url == null ? null : NetworkImage(url),
        child: url == null
            ? const Icon(
                Icons.person,
                size: 50,
              )
            : null,
      ),
      left: 0,
      top: 0,
      bottom: 0);
}
