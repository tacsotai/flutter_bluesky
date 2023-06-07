import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';

late int profIndex;

/// avatar widget
/// avarot link is profile page. see select index of [Base]
Widget avatar(BuildContext context, String? url,
    {double radius = 35, Function? func}) {
  return InkWell(
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
  );
}
