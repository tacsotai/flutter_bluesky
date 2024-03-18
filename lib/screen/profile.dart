import 'package:flutter/material.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/factory.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/profile/profile_view.dart';

class Profile extends StatefulWidget {
  static Screen screen = Screen(Profile, const Icon(Icons.person));
  const Profile({Key? key, this.actor}) : super(key: key);
  final String? actor;

  @override
  ProfileScreen createState() => ProfileScreen();
}

class ProfileScreen extends State<Profile> {
  final ProfileDataManager _manager = managerFactory!.getProfileDataManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    base!.screen.byOutside = true;
    return Scaffold(
      body: Stack(children: [
        _build(),
        base!.screen.bottom,
      ]),
    );
  }

  Widget _build() {
    _manager.holder.actor = widget.actor!;
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
            return ProfileView(
              manager: _manager,
              baseScreen: Base().screen,
            );
          }
        });
  }
}
