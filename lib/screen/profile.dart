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
  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.bottom,
      isPost: true,
    );
  }

  @override
  Widget body() {
    return Center(child: Text("screen: ${Profile.screen.name}"));
  }
}
