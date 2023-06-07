import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';

late int profIndex;

/// avator widget
/// avarot link is profile page. see select index of [Base]
Widget avator(BuildContext context, String? url,
    {double radius = 35, Function? func}) {
  return padding(
      InkWell(
        child: CircleAvatar(
          radius: radius,
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundImage: url == null ? null : NetworkImage(url),
          child: url == null ? const Icon(Icons.person, size: 50) : null,
        ),
        onTap: () async {
          if (func == null) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Base(selectedIndex: profIndex),
            ));
          } else {
            func;
          }
        },
      ),
      left: 0,
      top: 0,
      bottom: 0);
}
