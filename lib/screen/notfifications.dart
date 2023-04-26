import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';

class Notifications extends PluggableWidget {
  static Screen screen = Screen(Notifications, const Icon(Icons.notifications));

  const Notifications({Key? key, required this.base}) : super(key: key);
  final Base base;

  @override
  NotificationsScreen createState() => NotificationsScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem => navi(screen);
}

class NotificationsScreen extends State<Notifications> with Frame {
  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.base.screen.bottom,
      isPost: false,
    );
  }

  @override
  Widget body() {
    return Center(child: Text("screen: ${Notifications.screen.name}"));
  }
}
