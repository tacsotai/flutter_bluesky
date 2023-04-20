import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/connecting.dart';
import 'package:flutter_bluesky/screen/parts/tiimeline.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:tuple/tuple.dart';

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

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Future(() async {
          await plugin.timeline(); // cursor指定
        });
      }
    });
  }

  late String cursor;
  late bool status;

  Future<List<Feed>> getFeeds() async {
    Tuple2 res = await plugin.timeline(); // TODO cursor
    status = res.item1 == 200;
    cursor = res.item2["cursor"];
    List<Feed> feeds = [];
    for (var element in res.item2["feed"]) {
      feeds.add(Feed(element));
    }
    // TODO append するコード
    return feeds;
  }

  // https://zenn.dev/sqer/articles/db20a4d735fb7e5928ba
  Widget body(BuildContext context) {
    return FutureBuilder(
      future: getFeeds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _body(snapshot);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _body(snapshot) {
    if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    }
    if (!snapshot.hasData) {
      return const Text("Not found the data.");
    } else {
      if (!status) {
        return listsBody(Connecting(context).listview());
      } else {
        return scroll(snapshot.data); // normal case
      }
    }
  }

  Widget scroll(List<Feed> feeds) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.separated(
        controller: _scrollController,
        separatorBuilder: (context, index) => const Divider(height: 0.5),
        itemCount: feeds.length,
        itemBuilder: (context, index) => _build(feeds[index]),
      ),
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
