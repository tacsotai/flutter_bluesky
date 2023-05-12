import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';
import 'package:flutter_bluesky/screen/parts/transfer/detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';

Widget postLineFrame(BuildContext context, Post post) {
  return Column(children: [
    Container(
      margin: const EdgeInsets.all(10),
      child: Padding(
          padding: const EdgeInsets.all(5), child: postLine(context, post)),
    ),
    const Divider(height: 0.5)
  ]);
}

Widget postLine(BuildContext context, Post post) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      avator(post.author.avatar),
      sizeBox,
      postContentFrame(context, post)
    ],
  );
}

Widget postContentFrame(BuildContext context, Post post) {
  return Expanded(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: postContent(context, post),
          )));
}

List<Widget> postContent(BuildContext context, Post post) {
  return [
    header(context, post.author, post.record.createdAt),
    contentBody(context, post),
    footer(context, post),
  ];
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

Widget footer(BuildContext context, Post post) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      reply(context, post),
      repost(context, post),
      like(context, post),
      more(context, post),
    ],
  );
}

Widget contentBody(BuildContext context, Post post) {
  List<Widget> widgets = [];
  appendRecord(context, widgets, post);
  appendEmbed(context, widgets, post.embed);
  return Column(children: widgets);
}

void appendRecord(BuildContext context, List<Widget> widgets, Post post) {
  Widget text = Row(
    children: [
      Expanded(child: Text(post.record.text)),
    ],
  );
  widgets.add(
      Detector.instance(context, text).thread(post.author.handle, post.uri));
}

void appendEmbed(BuildContext context, List<Widget> widgets, Embed? embed) {
  if (embed == null) {
    return;
  }
  // debugPrint("embed.type: ${embed.type}");
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
