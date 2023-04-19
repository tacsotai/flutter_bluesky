import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static Screen screen = Screen(Home, const Icon(Icons.home_outlined));

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with Base {
  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: Text(Home.screen.name),
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
    return [];
  List<Widget> listview(BuildContext context, {Tuple2? res}) {
  }
}
