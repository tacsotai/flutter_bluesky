// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/image/banner.dart' as prof;
import 'package:flutter_bluesky/screen/parts/image/picture.dart';
import 'package:flutter_bluesky/util/image_util.dart';
import 'package:tuple/tuple.dart';

class ProfileUpdater {
  final FlutterBluesky plugin;
  final String? displayName;
  final String? description;
  final Avatar? avatar;
  final prof.Banner? banner;

  ProfileUpdater(
    this.plugin,
    this.displayName,
    this.description,
    this.avatar,
    this.banner,
  );

  Future<void> save() async {
    await plugin.updateProfile(
      displayName: displayName,
      description: description,
      avatar: await map(avatar!),
      banner: await map(banner!),
    );
  }

  Future<Map?> map(Picture pic) async {
    if (pic.file != null) {
      ImageFile file = pic.file!;
      return upload(await file.bytes, file.mimeType!);
    } else if (pic.url != null) {
      // empty is the signal of unchaned in this project.
      return {};
    }
    return null;
  }

  Future<Map> upload(Uint8List bytes, String contentType) async {
    Tuple2 res = await plugin.uploadBlob(bytes, contentType);
    return res.item2["blob"];
  }
}
