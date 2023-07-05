import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/notifications/notifications_view.dart';
import 'package:flutter_bluesky/screen/parts/menu.dart';

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
  final NotificationsDataManager _manager = NotificationsDataManager();
  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.base.screen.bottom,
      isPost: false,
      drawer: drawer,
    );
  }

  @override
  Widget body() {
    return FutureBuilder(
        future: _manager.getData(false),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return NotificationsView(
              manager: _manager,
              baseScreen: widget.base.screen,
            );
          }
        });
  }
}
