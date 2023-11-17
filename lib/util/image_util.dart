import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

  static Image image(PlatformFile file) {
    return file.bytes != null
        ? Image.memory(file.bytes!) // web case
        : Image.file(File(file.path!)); // ios, android case
  }
}

// https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
const int maxSize = 1000000; // 1MB

class ImageFile {
  final PlatformFile file;
  final Uint8List origin;
  final String? mimeType;

  ImageFile(this.file)
      : origin = file.bytes ?? File(file.path!).readAsBytesSync(),
        mimeType = ImageUtil.exts[path.extension(file.name).substring(1)];

  Uint8List get bytes {
    if (origin.length > maxSize) {
      return resize(origin);
    } else {
      return origin;
    }
  }

  Uint8List resize(Uint8List bytes, {int count = 0}) {
    img.Image image = img.decodeImage(bytes)!;
    image = img.copyResize(image, width: width(bytes, image, count));
    Uint8List resized = encode(image);
    // debugPrint("resized.length: ${resized.length}");
    // check the size
    if (resized.length > maxSize) {
      count++;
      resized = resize(resized, count: count);
    }
    return resized;
  }

  int width(Uint8List bytes, img.Image image, int count) {
    double ratio = maxSize / bytes.length;
    ratio = count < 2 ? sqrt(ratio) : ratio;
    // debugPrint("count: $count");
    // debugPrint("ratio: $ratio");
    return (image.width * ratio).toInt();
  }

  Uint8List encode(img.Image image) {
    switch (mimeType) {
      case "image/jpeg":
        // best trade off between speed and quality, may be
        return img.encodeJpg(image, quality: 85);
      case "image/png":
        // https://github.com/brendan-duncan/archive/blob/main/lib/src/zlib/deflate.dart#L11
        return img.encodePng(image, level: 9); // 9 = BEST_COMPRESSION
      default:
        throw UnimplementedError("Only Jpeg and Png are supported.");
    }
  }
}
