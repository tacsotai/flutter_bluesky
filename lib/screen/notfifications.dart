import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Notifications extends StatefulWidget {
  static Screen screen = Screen(Notifications, const Icon(Icons.notifications));
  const Notifications({Key? key, required this.bottom, required this.hide})
      : super(key: key);
  final Widget bottom;
  final void Function(bool) hide;

  @override
  NotificationsScreen createState() => NotificationsScreen();
}

class NotificationsScreen extends State<Notifications> with Frame {
  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Notifications'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Stack(children: [
        body(),
        widget.bottom,
      ]),
    );
  }

  Widget body() {
    return Center(child: Text("screen: ${Notifications.screen.name}"));
  }
}
