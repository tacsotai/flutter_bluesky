import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/home/infinity_list_view.dart';
import 'package:flutter_bluesky/screen/home/feed_maker.dart';

// https://blog.flutteruniv.com/flutter-infinity-scroll/
// https://api.flutter.dev/flutter/material/SliverAppBar-class.html
class Home extends PluggableWidget {
  static Screen screen = Screen(Home, const Icon(Icons.home));
  const Home({Key? key, required this.base}) : super(key: key);
  final Base base;

  @override
  HomeScreen createState() => HomeScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem => navi(screen);
}

class HomeScreen extends State<Home> with Frame {
  final FeedMaker _feedMaker = FeedMaker();

  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.base.screen.bottom,
      isPost: true,
      drawer: const Drawer(), // TODO
    );
  }

  @override
  Widget body() {
    return FutureBuilder(
        future: _feedMaker.getFeeds(false),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return InfinityListView(
              feeds: _feedMaker.feeds,
              getFeeds: _feedMaker.getFeeds,
              baseScreen: widget.base.screen,
            );
          }
        });
  }
}
