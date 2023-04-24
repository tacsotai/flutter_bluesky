import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';

import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter_bluesky/screen/home/infinity_list_view.dart';
import 'package:tuple/tuple.dart';

// https://blog.flutteruniv.com/flutter-infinity-scroll/
// https://api.flutter.dev/flutter/material/SliverAppBar-class.html
class Home extends StatefulWidget {
  static Screen screen = Screen(Home, const Icon(Icons.home));
  const Home({Key? key, required this.bottom, required this.hideBottom})
      : super(key: key);
  final Widget bottom;
  final void Function(bool) hideBottom;

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with Frame {
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
        future: getFeeds(false),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return InfinityListView(
              feeds: feeds,
              getFeeds: getFeeds,
              hide: widget.hideBottom,
            );
          }
        });
  }

  String? cursor;
  List<Feed> feeds = [];

  Future<void> getFeeds(bool insert) async {
    Tuple2 res = await plugin.timeline(cursor: insert ? null : cursor);
    cursor = res.item2["cursor"];
    List<Feed> list = _getList(res.item2["feed"]);
    insert ? feeds.insertAll(0, list) : feeds.addAll(list);
  }

  List<Feed> _getList(List feeds) {
    List<Feed> list = [];
    for (var element in feeds) {
      list.add(Feed(element));
    }
    return list;
  }
}
