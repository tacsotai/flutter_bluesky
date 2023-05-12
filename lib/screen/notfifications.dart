import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';

// ignore: must_be_immutable
class Notifications extends PluggableWidget {
  static Screen screen = Screen(Notifications, const Icon(Icons.notifications));

  Notifications({Key? key}) : super(key: key);
  late Base base;

  @override
  NotificationsScreen createState() => NotificationsScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem => navi(screen);

  @override
  void setBase(Base base) {
    this.base = base;
  }
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
