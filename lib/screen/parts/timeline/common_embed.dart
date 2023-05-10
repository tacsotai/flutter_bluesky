import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';

class CommonEmbed {
  void append(List<Widget> widgets, Embed? embed) {
    if (embed == null || embed.images == null) {
      return;
    }
    // debugPrint("embed.type: ${embed.type}");
    if (embed.type == 'app.bsky.embed.images#view') {
      internals(widgets, embed.internals);
    } else if (embed.type == 'app.bsky.embed.external#view') {
      external(widgets, embed.external);
    } else if (embed.type == 'app.bsky.embed.record#view') {
      record(widgets, embed.record);
    } else if (embed.type == 'app.bsky.embed.recordWithMedia#view') {
      recordWithMedia(widgets, embed.recordWithMedia);
    }
  }

  void internals(List<Widget> widgets, List<Internal> internals) {
    List<Widget> imgs = _images(internals);
    if (imgs.length == 1) {
      widgets.add(Row(children: [Expanded(child: imgs[0])]));
    } else if (imgs.length == 2) {
      widgets.add(
          Row(children: [Expanded(child: imgs[0]), Expanded(child: imgs[1])]));
    } else if (imgs.length == 3) {
      widgets.add(Row(children: [
        Flexible(flex: 2, child: Column(children: [imgs[0]])),
        Flexible(flex: 1, child: Column(children: [imgs[1], imgs[2]])),
      ]));
    } else if (imgs.length == 4) {
      widgets.add(Row(children: [
        Expanded(child: Column(children: [imgs[0], imgs[1]])),
        Expanded(child: Column(children: [imgs[2], imgs[3]])),
      ]));
    } else {
      // TODO over 5
      debugPrint("embed.type internal length: ${imgs.length}");
    }
  }

  List<Widget> _images(List<Internal> internals) {
    List<Widget> images = [];
    for (Internal internal in internals) {
      images.add(Image.network(internal.thumb));
    }
    return images;
  }

  void external(List<Widget> widgets, External external) {
    widgets.add(Expanded(child: Image.network(external.uri)));
  }

  void record(List<Widget> widgets, Record record) {
    debugPrint("embed.type record TODO implement");
  }

  void recordWithMedia(List<Widget> widgets, RecordWithMedia recordWithMedia) {
    debugPrint("embed.type recordWithMedia TODO implement");
  }
}
