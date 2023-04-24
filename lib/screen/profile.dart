import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Profile extends StatefulWidget {
  static Screen screen = Screen(Profile, const Icon(Icons.person));
  const Profile({Key? key, required this.bottom, required this.hideBottom})
      : super(key: key);
  final Widget bottom;
  final void Function(bool) hideBottom;

  @override
  ProfileeScreen createState() => ProfileeScreen();
}

class ProfileeScreen extends State<Profile> with Frame {
  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Profile'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Stack(children: [
        body(),
        widget.bottom,
      ]),
      floatingActionButton: Container(
          padding: const EdgeInsets.only(bottom: 50), child: post(context)),
    );
  }

  Widget body() {
    return Center(child: Text("screen: ${Profile.screen.name}"));
  }
}
