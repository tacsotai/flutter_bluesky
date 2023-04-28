import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/profile/profile_view.dart';

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
