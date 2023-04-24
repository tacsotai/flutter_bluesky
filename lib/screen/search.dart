import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Search extends StatefulWidget {
  static Screen screen = Screen(Search, const Icon(Icons.search));
  const Search({Key? key, required this.bottom, required this.hide})
      : super(key: key);
  final Widget bottom;
  final void Function(bool) hide;

  @override
  SearcheScreen createState() => SearcheScreen();
}

class SearcheScreen extends State<Search> with Frame {
  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Search'),
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
    );
  }

  Widget body() {
    return Center(child: Text("screen: ${Search.screen.name}"));
  }
}
