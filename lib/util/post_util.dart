import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/util/facet_util.dart';
import 'package:flutter_bluesky/util/image_util.dart';
import 'package:tuple/tuple.dart';

class PostUtil {
  // text or image can be empty, record may reply or quote.
  static Future<Tuple2> post(String? text, BuildContext context,
      {Map<String, dynamic>? record, required List<PlatformFile> files}) async {
    _validate(text, files);
    Poster poster = Poster(text!, context, record ??= {}, files);
    return await plugin.post(await poster.createRecord());
  }

  static void _validate(String? text, List<PlatformFile> files) {
    if (text == null && files.isEmpty) {
      throw Exception("Did you want to say anything?"); // TODO
    }
  }
}

class Poster {
  final String text;
  final BuildContext context;
  final Map<String, dynamic> record;
  final List<PlatformFile> files;
  Poster(this.text, this.context, this.record, this.files);

  Future<Map<String, dynamic>> createRecord() async {
    await uploadImage();
    await FacetUtil.modify(text, record);
    setCreatedAt();
    setLangs();
    return record;
  }

  Future<void> uploadImage() async {
    List<ImageFile> imgFiles = [];
    for (var file in files) {
      imgFiles.add(ImageFile(file));
    }
    List<Map>? images = await plugin.upload(imgFiles);
    if (images != null) {
      record["embed"] = {"\$type": "app.bsky.embed.images", "images": images};
    }
  }

  void setCreatedAt() {
    record["createdAt"] = DateTime.now().toUtc().toIso8601String();
  }

  void setLangs() {
    try {
      Locale locale = Localizations.localeOf(context);
      record["langs"] = [locale.languageCode];
    } catch (e) {
      // Do nothing.
      // Set locale when the locale is set on context.
    }
  }
}
