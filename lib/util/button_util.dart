import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/post.dart';

FloatingActionButton fab(BuildContext context, String route, IconData icon) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.pushNamed(context, route);
    },
    backgroundColor: Theme.of(context).colorScheme.primary,
    child: Icon(icon, size: 30),
  );
}

FloatingActionButton postFAB(BuildContext context) {
  return fab(context, Post.screen.route, Icons.edit);
}
