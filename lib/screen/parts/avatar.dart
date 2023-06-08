import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/profile.dart';

class Avatar {
  final BuildContext context;
  final double radius;
  ImageProvider? provider;

  Avatar(this.context, {this.radius = 35});

  // get by url for user profile
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

  Avatar net(String? url) {
    provider = url == null ? null : NetworkImage(url);
    return this;
  }

  Avatar file(Uint8List? bytes) {
    provider = bytes == null ? null : MemoryImage(bytes);
    return this;
  }

  CircleAvatar get circleAvatar {
    return CircleAvatar(
      radius: radius,
      foregroundColor: Theme.of(context).colorScheme.primary,
      backgroundImage: provider,
      child: provider == null ? const Icon(Icons.person, size: 50) : null,
    );
  }
}
