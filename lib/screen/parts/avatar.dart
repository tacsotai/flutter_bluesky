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
    return InkWell(child: circleAvatar, onTap: () => _transfer());
  }

  void _transfer() {
    if (actor.did == plugin.api.session.actor!.did) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Base(selectedIndex: meIndex),
      ));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profile(user: actor.did)),
      );
    }
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
