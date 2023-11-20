import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

const imageQuality = 70;
const double maxWidth = 1440;
const ImageSource source = ImageSource.gallery;

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

  static Future<List<XFile>> pickMultiImage() async {
    return await ImagePicker().pickMultiImage(
      imageQuality: imageQuality,
      maxWidth: maxWidth,
    );
  }

  static Future<XFile?> pickImage() async {
    return await ImagePicker().pickImage(
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      source: source,
    );
  }

  static Image image(XFile pickedFile) {
    if (kIsWeb) {
      // see https://pub.dev/packages/image_picker_for_web#limitations-on-the-web-platform
      return Image.network(pickedFile.path); // web case
    } else {
      return Image.file(File(pickedFile.path)); // ios, android case
    }
  }
}

// https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/embed/images.json
const int maxSize = 1000000; // 1MB

class ImageFile {
  final XFile file;
  final String? mimeType;

  ImageFile(this.file)
      : mimeType = ImageUtil.exts[path.extension(file.name).substring(1)];

  Future<Uint8List> get bytes async {
    Uint8List object = await file.readAsBytes();
    return object;
  }
}
