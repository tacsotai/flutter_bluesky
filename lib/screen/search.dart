import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/parts/menu.dart';
import 'package:flutter_bluesky/screen/search/search_view.dart';

late int searchIndex;

// ignore: must_be_immutable
class Search extends PluggableWidget {
  static Screen screen = Screen(Search, const Icon(Icons.search));
  Search({Key? key}) : super(key: key);
  late Base base;

  @override
  SearchScreen createState() => SearchScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem => navi(screen);

  @override
  void setBase(Base base) {
    this.base = base;
  }
}

class SearchScreen extends State<Search> with Frame {
  final SearchDataManager _manager = SearchDataManager();
  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.base.screen.bottom,
      fab: null,
      drawer: drawer,
    );
  }

  @override
  Widget body() {
    return FutureBuilder(
        future: _manager.getData(excludeSelf),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return SearchView(
              manager: _manager,
              // baseScreen: widget.base.screen,
              baseScreen: base!.screen,
            );
          }
        });
  }

  bool get excludeSelf {
    return false;
  }
}
