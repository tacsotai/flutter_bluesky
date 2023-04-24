import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);
  static Screen screen = Screen(Search, const Icon(Icons.search));
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
        body: Text('TODO Implement'),
        floatingActionButton: post(context),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: bottomNavigationBarItems(),
        ));
  }
}
