import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);
  static Screen screen = Screen(Notifications, const Icon(Icons.notifications));

  @override
  NotificationsScreen createState() => NotificationsScreen();
}

class NotificationsScreen extends State<Notifications> with Base {
  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Notifications'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: Text('TODO Implement'),
        floatingActionButton: post(context),
        bottomNavigationBar: menu(context));
  }
}
