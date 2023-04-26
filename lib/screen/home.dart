import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/home/infinity_list_view.dart';
import 'package:flutter_bluesky/screen/home/timeline.dart';

// https://blog.flutteruniv.com/flutter-infinity-scroll/
// https://api.flutter.dev/flutter/material/SliverAppBar-class.html
class Home extends PluggableWidget {
  static Screen screen = Screen(Home, const Icon(Icons.home));
  const Home({Key? key, required this.bottom, required this.hideBottom})
      : super(key: key);
  final Widget bottom;
  final void Function(bool) hideBottom;

  @override
  HomeScreen createState() => HomeScreen();

  @override
  BottomNavigationBarItem get bottomNavigationBarItem => navi(screen);
}

class HomeScreen extends State<Home> with Frame {
  final Timeline _timeline = Timeline();

  @override
  Widget build(BuildContext context) {
    return scaffold(
      context,
      bottom: widget.bottom,
      isPost: true,
      drawer: const Drawer(), // TODO
    );
  }

  @override
  Widget body() {
    return FutureBuilder(
        future: _timeline.getFeeds(false),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return InfinityListView(
              feeds: _timeline.feeds,
              getFeeds: _timeline.getFeeds,
              hide: widget.hideBottom,
            );
          }
        });
  }
}
