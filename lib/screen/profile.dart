import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:tuple/tuple.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static Screen screen =
      Screen(Profile, const Icon(Icons.person_outline_rounded));
  @override
  ProfileeScreen createState() => ProfileeScreen();
}

class ProfileeScreen extends State<Profile> with Base {
  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Profile'),
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
