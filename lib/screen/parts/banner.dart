import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/util/image_util.dart';

class Banner {
  final BuildContext context;
  final double height;
  late ProfileViewDetailed actor;
  ImageProvider? provider;
  ImageFile? file;
  Banner(this.context, {this.height = 150});

  Banner net(ProfileViewDetailed actor) {
    this.actor = actor;
    provider = actor.banner == null ? null : NetworkImage(actor.banner!);
    return this;
  }

  void setImage(ImageFile imageFile) {
    file = imageFile;
    // ignore: unnecessary_null_comparison
    provider = file!.bytes == null ? null : MemoryImage(file!.bytes);
  }

  Widget get banner {
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
