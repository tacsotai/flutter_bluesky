import 'package:flutter/material.dart';

Widget avator(String? url) {
  if (url == null) {
    return const CircleAvatar(
      radius: 35,
      child: Icon(Icons.person_outline_rounded),
    );
  }
  return CircleAvatar(
    radius: 35,
    backgroundImage: NetworkImage(url),
  );
}
