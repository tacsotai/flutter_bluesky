import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Search extends StatefulWidget {
  static Screen screen = Screen(Search, const Icon(Icons.search));
  const Search({Key? key, required this.bottom, required this.hideBottom})
      : super(key: key);
  final Widget bottom;
  final void Function(bool) hideBottom;

  @override
  SearcheScreen createState() => SearcheScreen();
}

class SearcheScreen extends State<Search> with Frame {
  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.bottom,
      isPost: false,
    );
  }

  @override
  Widget body() {
    return Center(child: Text("screen: ${Search.screen.name}"));
  }
}
