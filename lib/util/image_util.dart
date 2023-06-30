import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

/// This util deals with file_picker and image_picker.
class ImageUtil {
  // https://github.com/bluesky-social/atproto/blob/main/packages/pds/src/image/util.ts
  // profile is same
  static Map<String, String> exts = {
    "jpg": "image/jpeg",
    "jpeg": "image/jpeg",
    "png": "image/png",
  };

  // https://github.com/bluesky-social/atproto/blob/main/packages/pds/src/image/util.ts
  static Map<String, String> externalExts = {
    "jpg": "image/jpeg",
    "jpeg": "image/jpeg",
    "png": "image/png",
    "gif": "image/gif",
    "svg": "image/svg+xml",
    "tif": "image/tiff",
    "tiff": "image/tiff",
    "webp": "image/webp",
  };

  // For file_picker
  static Future<void> postFiles(String text, Map<String, dynamic>? record,
      List<PlatformFile> files) async {
    List<ImageFile> imgFiles = [];
    for (var file in files) {
      imgFiles.add(ImageFile(file));
    }
    await plugin.upload(text, record, imgFiles);
  }

  static Image image(PlatformFile file) {
    return file.bytes != null
        ? Image.memory(file.bytes!) // web case
        : Image.file(File(file.path!)); // ios, android case
  }
}

class ImageFile {
  static const maxWidth = 450;
  final PlatformFile file;
  final Uint8List origin;
  final String? mimeType;
  ImageFile(this.file)
      : origin = file.bytes ?? File(file.path!).readAsBytesSync(),
        mimeType = ImageUtil.exts[path.extension(file.name).substring(1)];

  Uint8List get bytes {
    img.Image? original = img.decodeImage(origin);
    if (original!.width > maxWidth) {
      img.Image resized = img.copyResize(original, width: maxWidth);
      // debugPrint("resized!.width: ${resized.width}");
      return encode(resized);
    } else {
      return origin;
    }
  }

  Uint8List encode(img.Image image) {
    switch (mimeType) {
      case "image/jpeg":
        return Uint8List.fromList(img.encodeJpg(image));
      case "image/png":
        return Uint8List.fromList(img.encodePng(image));
      default:
        throw UnimplementedError("Only Jpeg and Png are supported.");
    }
  }
}
