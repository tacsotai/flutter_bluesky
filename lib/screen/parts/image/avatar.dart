import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/image/picture.dart';
import 'package:flutter_bluesky/screen/profile.dart';

const double tinyRadius = 10;
const double smallRadius = 20;
const double defaultRadius = 35;
const double largeRadius = 45;

class Avatar extends Picture {
  final BuildContext context;
  final double radius;
  late ProfileViewBasic actor;

  Avatar(this.context, {this.radius = defaultRadius});

  Widget get profile {
    return InkWell(
      child: widget,
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile(actor: actor.did)),
        );
      },
    );
  }

  Avatar net(ProfileViewBasic actor) {
    this.actor = actor;
    url = actor.avatar;
    provider = url == null ? null : NetworkImage(url!);
    return this;
  }

  @override
  CircleAvatar get widget {
    return CircleAvatar(
      radius: radius,
      foregroundColor: Theme.of(context).colorScheme.primary,
      backgroundImage: provider,
      child: provider == null
          ? Icon(Icons.person, size: 50 * (radius / defaultRadius))
          : null,
    );
  }
}
