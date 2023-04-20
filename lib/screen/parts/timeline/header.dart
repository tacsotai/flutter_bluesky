import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';

Widget when(BuildContext context, Record record) {
  return Text(datetime(context, record.createdAt));
}

Widget name(BuildContext context, Author author) {
  // debugPrint("context.size.width: ${context.size?.width}");
  return Wrap(children: [displayName(author), sizeBox, handle(author)]);
}

Widget displayName(Author author) {
  String? name = author.displayName;
  name ??= withoutDomain(author.handle);
  return Text(
    name,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}

Widget handle(Author author) {
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
