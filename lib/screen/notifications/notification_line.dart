import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/api/model/notification.dart' as notice;
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/image/avatar.dart';
import 'package:flutter_bluesky/screen/parts/timeline/body.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';

Notice? customNotice;

class NotificationsLine extends StatefulWidget {
  final notice.Notification notification;
  final Post? reasonPost;
  const NotificationsLine(
      {Key? key, required this.notification, required this.reasonPost})
      : super(key: key);
  @override
  NotificationsLineScreen createState() => NotificationsLineScreen();
}

class NotificationsLineScreen extends State<NotificationsLine> {
  @override
  Widget build(BuildContext context) {
    Notice notice = customNotice ?? Notice();
    return padding(notice.build(this, widget.notification, widget.reasonPost));
  }
}

class Notice {
  late State state;
  late notice.Notification notification;
  late Post? reasonPost;

  Widget build(
    State state,
    notice.Notification notification,
    Post? reasonPost,
  ) {
    this.state = state;
    this.notification = notification;
    this.reasonPost = reasonPost;
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
        return quote;
      default:
        return error;
    }
  }

  Widget iconContent(IconData data, Color iconColor) {
    List<Widget> widgets = [
      Avatar(state.context, radius: 20).net(notification.author).profile,
      Header(author: notification.author, createdAt: notification.indexedAt)
          .build(state.context)
    ];
    if (reasonPost != null) {
      widgets.add(Body(post: reasonPost!));
    }
    return paddingLR([
      SizedBox(width: 70, child: Icon(data, color: iconColor, size: 30))
    ], [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets)
    ]);
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

  Widget get avatarContent {
    return paddingLR([
      Avatar(state.context).net(notification.author).profile
    ], [
      Header(author: notification.author, createdAt: notification.indexedAt)
          .build(state.context),
      Body(post: reasonPost!),
    ]);
  }

  Widget get reply {
    return avatarContent;
  }

  Widget get repost {
    return avatarContent;
  }

  Widget get quote {
    return avatarContent;
  }

  Widget get error {
    return Text("Error: Not implemented for '${notification.reason}'");
  }
}
