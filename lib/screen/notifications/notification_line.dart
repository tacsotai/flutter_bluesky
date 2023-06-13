import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/notification.dart' as notice;
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

NotificationContent? customNotificationContent;

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
    return padding(paddingLR([
      Text("TODO")
    ], [
      contet,
    ]));
  }

  Widget get contet {
    NotificationContent sc = customNotificationContent ?? NotificationContent();
    return sc.build(this, widget.notification);
  }
}

class NotificationContent {
  Widget build(State state, notice.Notification notification) {
    return Text("notification TODO");
  }
}
