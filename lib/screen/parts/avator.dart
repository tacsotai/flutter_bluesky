import 'package:flutter/material.dart';

Widget avatar(String? url) {
  if (url == null) {
    return const CircleAvatar(
      radius: 40,
      child: Icon(Icons.person_outline_rounded),
    );
  }
  return CircleAvatar(
    radius: 40,
    backgroundImage: NetworkImage(url),
  );
}
