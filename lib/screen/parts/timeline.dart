import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';

class Timeline {
  final BuildContext context;
  final Feed feed;
  Timeline(this.context, this.feed);

  Widget build() {
    return Row(
      children: [
        avatar(feed.post.author.avatar),
        sizeBox,
        Expanded(child: content(feed)),
      ],
    );
  }

  Widget content(Feed feed) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          children: [header(feed), body(feed), footer(feed)],
        ));
  }

  Widget header(Feed feed) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 4, child: name(context, feed.post.author)),
            Flexible(flex: 1, child: when(context, feed.post.record)),
          ],
        ));
  }

  Widget body(Feed feed) {
    return Row(
      children: [
        Expanded(
            child: Text(
          feed.post.record.text,
          style: const TextStyle(fontSize: 16.0),
        )),
        // const Spacer(),
      ],
    );
  }

  Widget footer(Feed feed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(feed.post.replyCount.toString()),
        Text(feed.post.repostCount.toString()),
        Text(feed.post.likeCount.toString()),
      ],
    );
  }
}

Widget avatar(String? url) {
  if (url == null) {
    return const CircleAvatar(
      radius: 40,
      child: Icon(Icons.person_outline_rounded),
    );
  }
  return CircleAvatar(
    radius: 40,
    backgroundImage: NetworkImage(url),
  );
}

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
