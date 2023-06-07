import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';

late int profIndex;

class Avatar {
  final BuildContext context;
  final String? url;
  double radius = 35;

  Avatar(this.context, this.url, {double radius = 35});

  Widget get profile {
    return InkWell(
      child: circleAvatar,
      onTap: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Base(selectedIndex: profIndex),
        ));
      },
    );
  }

  Widget get picture {
    if (url == null) {
      return circleAvatar;
    } else {
      return InkWell(
        child: circleAvatar,
        onTap: () async {
          // TODO show original picture page.
        },
      );
    }
  }

  Widget get pick {
    return InkWell(
      child: circleAvatar,
      onTap: () async {
        // TODO pick file or take picture.
      },
    );
  }

  CircleAvatar get circleAvatar {
    debugPrint("url: $url");
    return CircleAvatar(
      radius: radius,
      foregroundColor: Theme.of(context).colorScheme.primary,
      backgroundImage: url == null ? null : NetworkImage(url!),
      child: url == null ? const Icon(Icons.person, size: 50) : null,
    );
  }
}
