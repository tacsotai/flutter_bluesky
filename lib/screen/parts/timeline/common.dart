import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/link/hyper_link.dart';
import 'package:flutter_bluesky/screen/parts/timeline/body.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';
import 'package:tuple/tuple.dart';

Widget text(String prop, BuildContext context) {
  return Text(
    tr(prop),
    style: TextStyle(
        color: Theme.of(context).useMaterial3
            ? Colors.black
            : Theme.of(context).secondaryHeaderColor),
  );
}

Widget lr(Widget left, Widget right, Tuple2<int, int> ratio) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(flex: ratio.item1, child: left),
      Flexible(flex: ratio.item2, child: right),
    ],
  );
}

Widget displayNameHandle(ProfileViewBasic actor) {
  return Wrap(children: [displayName(actor), sizeBox, handle(actor)]);
}

Widget displayName(ProfileViewBasic actor, {double? fontSize = 16}) {
  String? name = actor.displayName;
  name ??= withoutDomain(actor.handle);
  return Text(
    name,
    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
  );
}

Widget handle(ProfileViewBasic actor) {
  return Text(
    '@${actor.handle}',
    style: const TextStyle(color: Colors.grey),
  );
}

Widget description(ProfileView actor) {
  String desc = actor.description ?? "";
  return HyperLink(desc).withLink;
}

Widget count(int count, String postfix) {
  return Row(children: [
    bold(count),
    Text(postfix, style: const TextStyle(color: Colors.grey)),
  ]);
}

Widget bold(int count) {
  return Text(count.toString(),
      style: const TextStyle(fontWeight: FontWeight.bold));
}

String withoutDomain(String handle) {
  for (var domain in plugin.serverDescription["availableUserDomains"]) {
    if (handle.endsWith(domain)) {
      handle = handle.replaceAll(domain, '');
    }
  }
  return handle;
}

Widget outline(Widget widget) {
  return Column(children: [
    Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: widget,
    ),
    const Divider(height: 0.5)
  ]);
}

Widget leftPadding(List<Widget> lefts) {
  return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lefts,
      ));
}

Widget rightPadding(List<Widget> rights) {
  return Expanded(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rights,
          )));
}

Widget paddingLR(List<Widget> lefts, List<Widget> rights) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [leftPadding(lefts), rightPadding(rights)],
  );
}

Widget embedBox(Widget widget) {
  return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: widget);
}

Widget imageDecoration(Widget widget) {
  return padding2(ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: widget,
  ));
}

mixin Common {
  List<Widget> content(Post post) {
    return [
      Header(author: post.author, createdAt: post.record.createdAt),
      Body(post: post),
      Footer(post: post),
    ];
  }

  Widget postTL(BuildContext context, Post post) {
    return paddingLR([
      Avatar(context).net(post.author).profile,
    ], content(post));
  }
}
