import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/api/model/notification.dart' as notice;
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/timeline/body.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';
import 'package:flutter_bluesky/screen/parts/timeline/reply_tl.dart';

Notice? customNotice;

class NotificationsLine extends StatefulWidget {
  final notice.Notification notification;
  final Post? post;
  const NotificationsLine(
      {Key? key, required this.notification, required this.post})
      : super(key: key);
  @override
  NotificationsLineScreen createState() => NotificationsLineScreen();
}

class NotificationsLineScreen extends State<NotificationsLine> {
  @override
  Widget build(BuildContext context) {
    Notice notice = customNotice ?? Notice();
    return padding10(notice.build(this, widget.notification, widget.post));
  }
}

class Notice {
  late State state;
  late notice.Notification notification;
  late Post? post;

  Widget build(
    State state,
    notice.Notification notification,
    Post? post,
  ) {
    this.state = state;
    this.notification = notification;
    this.post = post;
    switch (notification.reason) {
      case "follow":
        return follow;
      case "like":
        return like;
      case "reply":
        return reply;
      case "repost":
        return repost;
      case "quote":
        return avatarContent(body(post!));
      case "mention":
        return avatarContent(body(post!));
      default:
        return error;
    }
  }

  Widget iconContent(IconData data, Color iconColor) {
    List<Widget> widgets = [
      Avatar(state.context, radius: smallRadius).net(author).profile,
      Header(author: author, createdAt: notification.indexedAt)
          .build(state.context)
    ];
    if (post != null) {
      widgets.add(body(post!));
    }
    return paddingLR([
      SizedBox(width: 70, child: Icon(data, color: iconColor, size: 30))
    ], [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets)
    ]);
  }

  Widget avatarContent(Widget body) {
    return paddingLR([
      Avatar(state.context).net(author).profile
    ], [
      Header(author: author, createdAt: notification.indexedAt)
          .build(state.context),
      body,
    ]);
  }

  ProfileViewBasic get author {
    return ProfileViewBasic(notification.author);
  }

  Widget get follow {
    return iconContent(
      Icons.person_add,
      Colors.blue,
    );
  }

  Widget get like {
    return iconContent(
      Icons.favorite_sharp,
      Colors.pink,
    );
  }

  Widget get reply {
    Widget widget = Column(
      children: [replyHeader(actorName(post!.author)), body(Post(replyPost))],
    );
    return avatarContent(widget);
  }

  Widget get repost {
    return iconContent(
      Icons.repeat,
      Colors.green,
    );
  }

  Widget body(Post post) {
    return Body(post: post);
  }

  Map get replyPost {
    return {
      "uri": notification.uri,
      "cid": notification.cid,
      "author": notification.author,
      "record": notification.record,
      "indexedAt": notification.indexedAt.toIso8601String(),
    };
  }

  Widget get error {
    return Text("Error: Not implemented for '${notification.reason}'");
  }
}
