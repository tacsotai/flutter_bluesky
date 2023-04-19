import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:tuple/tuple.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);
  static Screen screen =
      Screen(Notifications, const Icon(Icons.notifications_outlined));

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
        body: lists(context),
        floatingActionButton: post(context),
        bottomNavigationBar: menu(context));
  }

  @override
  List<Widget> listview(BuildContext context, {Tuple2? res}) {
    return [];
  }
}
