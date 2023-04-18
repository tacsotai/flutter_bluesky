import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

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
        body: lists(context),
        floatingActionButton: post(context),
        bottomNavigationBar: menu(context));
  }

  @override
  List<Widget> listview(BuildContext context) {
    return [];
  }
}