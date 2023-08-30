import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/profile.dart';
import 'package:flutter_bluesky/util/image_util.dart';

class Avatar {
  final BuildContext context;
  final double radius;
  late ProfileViewBasic actor;
  ImageProvider? provider;
  ImageFile? file;

  Avatar(this.context, {this.radius = 35});

  Widget get profile {
    return InkWell(
      child: circleAvatar,
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile(user: actor.did)),
        );
      },
    );
  }

  Avatar net(ProfileViewBasic actor) {
    this.actor = actor;
    provider = actor.avatar == null ? null : NetworkImage(actor.avatar!);
    return this;
  }

  void setImage(ImageFile imageFile) {
    file = imageFile;
    // ignore: unnecessary_null_comparison
    provider = file!.bytes == null ? null : MemoryImage(file!.bytes);
  }

  CircleAvatar get circleAvatar {
    return CircleAvatar(
      radius: radius,
      foregroundColor: Theme.of(context).colorScheme.primary,
      backgroundImage: provider,
      child: provider == null
          ? Icon(Icons.person, size: 50 * (radius / 35))
          : null,
    );
  }
}
