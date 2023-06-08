import 'dart:typed_data';
import 'package:flutter/material.dart';

class Banner {
  final BuildContext context;
  final double height;
  ImageProvider? provider;

  Banner(this.context, {this.height = 150});

  Banner net(String? url) {
    provider = url == null ? null : NetworkImage(url);
    return this;
  }

  Banner file(Uint8List? bytes) {
    provider = bytes == null ? null : MemoryImage(bytes);
    return this;
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
