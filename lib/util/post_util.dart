import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';
import 'package:flutter_bluesky/screen/parts/post/post_delete.dart';
import 'package:flutter_bluesky/screen/parts/post/post_report.dart';
import 'package:flutter_bluesky/util/common_util.dart';
import 'package:flutter_bluesky/util/facet_util.dart';
import 'package:flutter_bluesky/util/image_util.dart';
import 'package:tuple/tuple.dart';

class PostUtil {
  // text or image can be empty, record may reply or quote.
  static Future<Tuple2> post(String? text, BuildContext context,
      {Map<String, dynamic>? record, required List<XFile> files}) async {
    _validate(text, files);
    Poster poster = Poster(text!, context, record ??= {}, files);
    return await plugin.post(await poster.createRecord());
  }

  static void _validate(String? text, List<XFile> files) {
    if (text == null && files.isEmpty) {
      throw Exception("Did you want to say anything?"); // TODO
    }
  }

  static Future<void> delete(BuildContext context, Post post) async {
    PostDelete modal = PostDelete(post: post);
    await showModal(context, modal);
    if (modal.button.actionStatus == ActionStatus.completed) {
      // ignore: use_build_context_synchronously
      await timerDialog(context, dialog("post.deleted"));
    }
    // TODO error case
  }

  static Future<void> report(BuildContext context, Post post) async {
    PostReport modal = PostReport(post: post);
    await showModal(context, modal);
    if (modal.button.actionStatus == ActionStatus.completed) {
      // ignore: use_build_context_synchronously
      await timerDialog(context, messageDialog("report.thank"));
    }
    // TODO error case
  }
}

class Poster {
  final String text;
  final BuildContext context;
  final Map<String, dynamic> record;
  final List<XFile> files;
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
