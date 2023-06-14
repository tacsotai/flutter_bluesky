import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/notification.dart' as notice;
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avatar.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

Notice? customNotice;

class NotificationsLine extends StatefulWidget {
  final notice.Notification notification;
  const NotificationsLine({Key? key, required this.notification})
      : super(key: key);
  @override
  NotificationsLineScreen createState() => NotificationsLineScreen();
}

class NotificationsLineScreen extends State<NotificationsLine> {
  @override
  Widget build(BuildContext context) {
    Notice notice = customNotice ?? Notice();
    return padding(notice.build(this, widget.notification));
  }
}

class Notice {
  Widget build(State state, notice.Notification notification) {
    switch (notification.reason) {
      case "follow":
        return follow(state, notification);
      case "reply":
        return reply(state, notification);
      case "like":
        return like(state, notification);
      case "repost":
        return repost(state, notification);
      default:
        return error(state, notification);
    }
  }

  Widget follow(State state, notice.Notification notification) {
    return paddingLR([
      const Icon(Icons.favorite_sharp, color: Colors.pink)
    ], [
      Column(
        children: [
          Avatar(state.context).net(notification.author).profile,
          displayName(notification.author),
        ],
      )
    ]);
  }

  Widget reply(State state, notice.Notification notification) {
    return paddingLR([
      Avatar(state.context).net(notification.author).profile
    ], [
      Text(notification.record["text"]),
    ]);
  }

  Widget like(State state, notice.Notification notification) {
    return Text("notification.reason ${notification.reason}");
  }

  Widget repost(State state, notice.Notification notification) {
    return Text("notification.reason ${notification.reason}");
  }

  Widget error(State state, notice.Notification notification) {
    return Text("Error: Not implementd for '${notification.reason}'");
  }
}
