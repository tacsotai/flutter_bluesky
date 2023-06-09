import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/me.dart';
import 'package:flutter_bluesky/screen/profile.dart';

class Avatar {
  final BuildContext context;
  final double radius;
  late ProfileViewBasic actor;
  ImageProvider? provider;

  Avatar(this.context, {this.radius = 35});

  Widget get profile {
    return InkWell(
      child: circleAvatar,
      onTap: () async {
        if (actor.did == plugin.api.session.actor!.did) {
          transfer(Base(selectedIndex: meIndex));
        } else {
          transfer(Profile(user: actor.did));
        }
      },
    );
  }

  void transfer(Widget widget) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => widget,
    ));
  }

  Avatar net(ProfileViewBasic actor) {
    this.actor = actor;
    provider = actor.avatar == null ? null : NetworkImage(actor.avatar!);
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
