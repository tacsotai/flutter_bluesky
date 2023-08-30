import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/image/picture.dart';

class Banner extends Picture {
  final BuildContext context;
  final double height;
  late ProfileViewDetailed actor;
  Banner(this.context, {this.height = 150});

  Banner net(ProfileViewDetailed actor) {
    this.actor = actor;
    url = actor.banner;
    provider = url == null ? null : NetworkImage(url!);
    return this;
  }

  @override
  Widget get widget {
    if (provider == null) {
      return plain;
    } else {
      return picture;
    }
  }

  Widget get picture {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: provider!,
        fit: BoxFit.cover,
      )),
    );
  }

  Widget get plain {
    return ColoredBox(
      color: Theme.of(context).colorScheme.primary,
      child: SizedBox(
        height: height,
        width: double.infinity,
      ),
    );
  }

  static Widget get blank {
    return const SizedBox(
      height: 30,
      width: double.infinity,
    );
  }
}
