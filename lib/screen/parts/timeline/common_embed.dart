import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common_base.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonEmbed extends CommonBase {
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
    Widget container = Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          recordHeader(context, embed.record),
          Text(embed.record.value.text),
        ],
      ),
    );
    widgets.add(container);
  }

  Widget recordHeader(BuildContext context, RecordView record) {
    return Row(
      children: [
        avator(record.author.avatar, radius: 10),
        sizeBox,
        Expanded(child: header(context, record.author, record.value.createdAt))
      ],
    );
  }

  void recordWithMedia(List<Widget> widgets, Embed embed) {
    if (embed.recordObj == null && embed.mediaObj == null) {
      return;
    }
    debugPrint("embed.type recordWithMedia TODO implement");
  }
}
