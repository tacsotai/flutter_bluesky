import 'package:flutter/material.dart';
import 'package:flutter_bluesky/util/image_util.dart';

abstract class Picture {
  ImageProvider? provider;
  ImageFile? file;
  String? url;

  void setImage(ImageFile imageFile) {
    file = imageFile;
    // ignore: unnecessary_null_comparison
    provider = file!.bytes == null ? null : MemoryImage(file!.bytes);
  }

  Widget get widget;
}
