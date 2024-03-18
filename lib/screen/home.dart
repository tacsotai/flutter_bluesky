import 'package:flutter/material.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/home/home_view.dart';
import 'package:flutter_bluesky/screen/parts/menu.dart';
import 'package:flutter_bluesky/util/button_util.dart';

// https://blog.flutteruniv.com/flutter-infinity-scroll/
// https://api.flutter.dev/flutter/material/SliverAppBar-class.html
// ignore: must_be_immutable
class Home extends PluggableWidget {
  static Screen screen = Screen(Home, const Icon(Icons.home));
  Home({Key? key}) : super(key: key);
  late Base base;

  @override
  HomeScreen createState() => HomeScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem => navi(screen);

  @override
  void setBase(Base base) {
    this.base = base;
  }
}

class HomeScreen extends State<Home> with Frame {
  final HomeDataManager _manager = HomeDataManager();

  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.base.screen.bottom,
      fab: postFAB(context),
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
            debugPrint("Error: $snapshot.error");
            return const LoginScreen();
          } else {
            return HomeView(
              manager: _manager,
              // baseScreen: widget.base.screen,
              baseScreen: base!.screen,
            );
          }
        });
  }
}
