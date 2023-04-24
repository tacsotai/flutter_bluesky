import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Notifications extends StatefulWidget {
  static Screen screen = Screen(Notifications, const Icon(Icons.notifications));
  const Notifications(
      {Key? key, required this.bottom, required this.hideBottom})
      : super(key: key);
  final Widget bottom;
  final void Function(bool) hideBottom;

  @override
  NotificationsScreen createState() => NotificationsScreen();
}

class NotificationsScreen extends State<Notifications> with Frame {
  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.bottom,
      isPost: false,
    );
  }

  @override
  Widget body() {
    return Center(child: Text("screen: ${Notifications.screen.name}"));
  }
}
