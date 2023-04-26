import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';

class Search extends PluggableWidget {
  static Screen screen = Screen(Search, const Icon(Icons.search));
  const Search({Key? key, required this.base}) : super(key: key);
  final Base base;

  @override
  SearcheScreen createState() => SearcheScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem => navi(screen);
}

class SearcheScreen extends State<Search> with Frame {
  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.base.screen.bottom,
      isPost: false,
    );
  }

  @override
  Widget body() {
    return Center(child: Text("screen: ${Search.screen.name}"));
  }
}
