import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';

Widget when(BuildContext context, Record record) {
  return Text(datetime(context, record.createdAt));
}

Widget name(BuildContext context, ProfileViewBasic author) {
  // debugPrint("context.size.width: ${context.size?.width}");
  return Wrap(children: [displayName(author, 18), sizeBox, handle(author)]);
}

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
