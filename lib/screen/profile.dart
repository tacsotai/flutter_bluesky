import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/profile/profile_view.dart';

class Profile extends StatefulWidget {
  static Screen screen = Screen(Profile, const Icon(Icons.person));
  const Profile({Key? key, this.user}) : super(key: key);
  final String? user;

  @override
  ProfileScreen createState() => ProfileScreen();
}

class ProfileScreen extends State<Profile> {
  final ProfileDataManager _manager = ProfileDataManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread'),
      ),
      body: _build(),
    );
  }

  Widget _build() {
    _manager.holder.user = widget.user!;
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
              baseScreen: Base().screen,
            );
          }
        });
  }
}
