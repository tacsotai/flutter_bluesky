import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/notifications/notifications_view.dart';
import 'package:flutter_bluesky/screen/parts/menu.dart';

// ignore: must_be_immutable
class Notifications extends PluggableWidget {
  static Screen screen = Screen(Notifications, const Icon(Icons.notifications));
  final NotificationsDataManager manager = NotificationsDataManager();

  Notifications({Key? key}) : super(key: key);

  @override
  NotificationsScreen createState() => NotificationsScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem =>
      navi(screen, icon: icon(screen));

  Widget icon(Screen screen) {
    return manager.read ? screen.icon : badge(screen);
  }

  Widget badge(Screen screen) {
    return Badge(
      backgroundColor: Colors.red,
      label: Text(
        manager.holder.unreadCount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      child: screen.icon,
    );
  }

  @override
  Future<void> init() async {
    if (hasSession) {
      await manager.count;
    }
  }
}

class NotificationsScreen extends State<Notifications> with Frame {
  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: base!.screen.bottom,
      fab: null,
      drawer: drawer,
    );
  }

  @override
  Widget body() {
    return FutureBuilder(
        future: widget.manager.getData(false),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint("Error: $snapshot.error");
            return const LoginScreen();
          } else {
            return NotificationsView(
              manager: widget.manager,
              baseScreen: base!.screen,
            );
          }
        });
  }
}
