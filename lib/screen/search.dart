import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);
  static Screen screen = Screen(Search, const Icon(Icons.search_outlined));
  @override
  SearcheScreen createState() => SearcheScreen();
}

class SearcheScreen extends State<Search> with Base {
  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Search'),
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
