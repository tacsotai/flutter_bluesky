import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/avator.dart';
import 'package:flutter_bluesky/screen/parts/timeline/body.dart';
import 'package:flutter_bluesky/screen/parts/timeline/footer.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';

Widget displayName(ProfileViewBasic author, double? fontSize) {
  String? name = author.displayName;
  name ??= withoutDomain(author.handle);
  return Text(
    name,
    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
  );
}

Widget handle(ProfileViewBasic author) {
  return InkWell(
    child: Text('@${author.handle}'),
    onTap: () async {
      // if (await canLaunch("url")) {
      //   await launch("url");
      // }
    },
  );
}

String withoutDomain(String handle) {
  for (var domain in plugin.serverDescription["availableUserDomains"]) {
    if (handle.endsWith(domain)) {
      handle.replaceAll(domain, '');
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

mixin Common {
  List<Widget> content(Post post) {
    return [
      Header(author: post.author, createdAt: post.record.createdAt),
      Body(post: post),
      Footer(post: post),
    ];
  }

  Widget postTL(BuildContext context, Post post) {
    return paddingLR([avator(context, post.author.avatar)], content(post));
  }
}
