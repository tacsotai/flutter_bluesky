import 'package:flutter/material.dart';

Widget avator(String? url, {double radius = 35}) {
  if (url == null) {
    return CircleAvatar(
      radius: radius,
      child: const Icon(Icons.person_outline_rounded),
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundImage: NetworkImage(url),
  );
}
