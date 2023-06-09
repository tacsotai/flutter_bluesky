import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/profile/profile_view.dart';

late int meIndex;

// ignore: must_be_immutable
class Me extends PluggableWidget {
  static Screen screen = Screen(Me, const Icon(Icons.person));
  Me({Key? key}) : super(key: key);
  late Base base;

  @override
  MyScreen createState() => MyScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem => navi(screen);

  @override
  void setBase(Base base) {
    this.base = base;
  }
}

class MyScreen extends State<Me> with Frame {
  final ProfileDataManager _manager = ProfileDataManager();
  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.base.screen.bottom,
      isPost: true,
    );
  }

  @override
  Widget body() {
    _manager.holder.user = plugin.api.session.handle ?? ""; // TODO other user
    return FutureBuilder(
        future: _manager.getData(false),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return ProfileView(
              manager: _manager,
              baseScreen: widget.base.screen,
            );
          }
        });
  }
}
