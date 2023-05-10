import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class CommonBase {
  void appendRecord(List<Widget> widgets, Record record) {
    Widget text = Row(
      children: [
        Expanded(child: Text(record.text)),
      ],
    );
    widgets.add(text);
  }

  void appendEmbed(BuildContext context, List<Widget> widgets, Embed? embed) {
    if (embed == null) {
      return;
    }
    debugPrint("embed.type: ${embed.type}");
    if (embed.type == 'app.bsky.embed.images#view') {
      internals(widgets, embed);
    } else if (embed.type == 'app.bsky.embed.external#view') {
      // external(widgets, embed);
    } else if (embed.type == 'app.bsky.embed.record#view') {
      record(context, widgets, embed);
    } else if (embed.type == 'app.bsky.embed.recordWithMedia#view') {
      // recordWithMedia(widgets, embed);
    }
  }

  void internals(List<Widget> widgets, Embed embed) {
    if (embed.imagesObj == null) {
      return;
    }
    List<Widget> imgs = _images(embed.internals);
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

  void external(List<Widget> widgets, Embed embed) {
    if (embed.externalObj == null) {
      return;
    }
    // TODO https://sashimistudio.site/flutter-webview/
    widgets.add(Row(children: [
      Expanded(
        child: InkWell(
          child: Text(embed.external.title),
          onTap: () => {launchUrl(Uri.parse(embed.external.uri))},
        ),
      )
    ]));
  }

  void record(BuildContext context, List<Widget> widgets, Embed embed) {
    if (embed.recordObj == null) {
      return;
    }
    Widget c = Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          header(context, embed.record.author, embed.record.value.createdAt),
          Text(embed.record.value.text),
        ],
      ),
    );
    widgets.add(c);
  }

  void recordWithMedia(List<Widget> widgets, Embed embed) {
    if (embed.recordObj == null && embed.mediaObj == null) {
      return;
    }
    debugPrint("embed.type recordWithMedia TODO implement");
  }

  Widget header(
      BuildContext context, ProfileViewBasic author, DateTime datetime) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 5, child: name(context, author)),
            Flexible(flex: 2, child: when(context, datetime)),
          ],
        ));
  }
}
