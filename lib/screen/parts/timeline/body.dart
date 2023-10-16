import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/link/facet_link.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';
import 'package:flutter_bluesky/screen/parts/transfer/detector.dart';
import 'package:flutter_bluesky/util/embed_util.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatelessWidget {
  final Post post;
  final double? fontSize;
  const Body({super.key, required this.post, this.fontSize});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    appendRecord(context, widgets, post, fontSize: fontSize);
    appendEmbed(context, widgets, post.embed);
    return Column(children: widgets);
  }

  void appendRecord(BuildContext context, List<Widget> widgets, Post post,
      {double? fontSize}) {
    FacetLink facetLink = FacetLink(post.record, context, fontSize: fontSize);
    Widget text = Row(
      children: [
        Expanded(child: facetLink.withLink),
      ],
    );
    widgets.add(Detector.instance(context, text).thread(post.author, post.uri));
  }

  void appendEmbed(BuildContext context, List<Widget> widgets, Embed? embed) {
    if (embed == null) {
      return;
    }
    // debugPrint("embed.type: ${embed.type}");
    if (embed.type == 'app.bsky.embed.images#view') {
      images(widgets, embed);
    } else if (embed.type == 'app.bsky.embed.external#view') {
      // external(widgets, embed);
    } else if (embed.type == 'app.bsky.embed.record#view') {
      record(context, widgets, embed);
    } else if (embed.type == 'app.bsky.embed.recordWithMedia#view') {
      // recordWithMedia(widgets, embed);
    }
  }

  void images(List<Widget> widgets, Embed embed) {
    if (embed.imagesObj == null) {
      return;
    }
    if (embed.images.isNotEmpty) {
      widgets.add(EmbedUtil.arrange(embed.images));
    }
  }

  List<Widget> _images(List<Images> internals) {
    List<Widget> images = [];
    for (Images internal in internals) {
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
    Widget container = embedBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          recordHeader(context, embed.record),
          Text(embed.record.value.text),
        ],
      ),
    );
    widgets.add(Detector.instance(context, container)
        .thread(embed.record.author, embed.record.uri));
  }

  Widget recordHeader(BuildContext context, RecordView record) {
    return Row(
      children: [
        Avatar(context, radius: 10).net(record.author).profile,
        Expanded(
            child: Header(
                author: record.author, createdAt: record.value.createdAt))
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
