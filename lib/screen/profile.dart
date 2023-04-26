import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';

class Profile extends PluggableWidget {
  static Screen screen = Screen(Profile, const Icon(Icons.person));
  const Profile({Key? key, required this.base}) : super(key: key);
  final Base base;

  @override
  ProfileeScreen createState() => ProfileeScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem => navi(screen);
}

class ProfileeScreen extends State<Profile> with Frame {
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
    return Center(child: Text("screen: ${Profile.screen.name}"));
  }
}
