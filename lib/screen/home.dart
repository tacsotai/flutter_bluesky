import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/timeline.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:tuple/tuple.dart';

// https://blog.flutteruniv.com/flutter-infinity-scroll/
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static Screen screen = Screen(Home, const Icon(Icons.home_outlined));

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with Base {
  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: Text(Home.screen.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: body(context),
        floatingActionButton: post(context),
        bottomNavigationBar: menu(context));
  }

  String? cursor;
  List<Feed> feeds = [];

  Future<void> getFeeds() async {
    Tuple2 res = await plugin.timeline(cursor: cursor);
    cursor = res.item2["cursor"];
    List<Feed> list = [];
    for (var element in res.item2["feed"]) {
      list.add(Feed(element));
    }
    feeds.addAll(list);
  }

  Widget body(BuildContext context) {
    return FutureBuilder(
      future: getFeeds(),
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
          );
        }
      },
    );
  }
}

class InfinityListView extends StatefulWidget {
  final List<Feed> feeds;
  final Future<void> Function() getFeeds;

  const InfinityListView({
    Key? key,
    required this.feeds,
    required this.getFeeds,
  }) : super(key: key);

  @override
  State<InfinityListView> createState() => _InfinityListViewState();
}

class _InfinityListViewState extends State<InfinityListView> {
  //5
  late ScrollController _scrollController;
  //6
  bool _isLoading = false;

  //7
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !_isLoading) {
        _isLoading = true;

        await widget.getFeeds();

        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  //8
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      //9
      controller: _scrollController,
      //10
      itemCount: widget.feeds.length + 1,
      separatorBuilder: (BuildContext context, int index) => Container(
        width: double.infinity,
        height: 0.5,
        color: Colors.grey,
      ),
      itemBuilder: (BuildContext context, int index) {
        //11
        if (widget.feeds.length == index) {
          return const SizedBox(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _build(widget.feeds[index]);
      },
    );
  }

  Widget _build(Feed feed) {
    Timeline line = Timeline(context, feed);
    return Container(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: line.build(),
      ),
    );
  }
}
