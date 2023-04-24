import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/timeline.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/rendering.dart';

// https://blog.flutteruniv.com/flutter-infinity-scroll/
// https://api.flutter.dev/flutter/material/SliverAppBar-class.html
class Home extends StatefulWidget {
  static Screen screen = Screen(Home, const Icon(Icons.home));
  const Home({Key? key, required this.bottom, required this.hide})
      : super(key: key);
  final Widget bottom;
  final void Function(bool) hide;

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with Frame {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        body(),
        widget.bottom,
      ]),
      floatingActionButton: Container(
          padding: const EdgeInsets.only(bottom: 50), child: post(context)),
      drawer: const Drawer(),
    );
  }

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
              hide: widget.hide,
            );
          }
        });
  }

  String? cursor;
  List<Feed> feeds = [];

  Future<void> getFeeds(bool insert) async {
    Tuple2 res = await plugin.timeline(cursor: cursor);
    cursor = res.item2["cursor"];
    List<Feed> list = [];
    for (var element in res.item2["feed"]) {
      list.add(Feed(element));
    }
    if (insert) {
      feeds.insertAll(0, list);
      // for (var feed in feeds) {
      //   debugPrint("displayName: ${feed.post.author.displayName}");
      // }
    } else {
      feeds.addAll(list);
    }
  }
}

class InfinityListView extends StatefulWidget {
  final List<Feed> feeds;
  final Future<void> Function(bool) getFeeds;
  final void Function(bool) hide;

  const InfinityListView({
    Key? key,
    required this.feeds,
    required this.getFeeds,
    required this.hide,
  }) : super(key: key);

  @override
  State<InfinityListView> createState() => _InfinityListViewState();
}

class _InfinityListViewState extends State<InfinityListView> {
  late ScrollController _scrollController;
  bool isHidden = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isHidden) {
          widget.hide(true);
          isHidden = true;
        }
      } else {
        if (isHidden) {
          widget.hide(false);
          isHidden = false;
        }
      }
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !_isLoading) {
        _isLoading = true;

        await widget.getFeeds(false);

        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Widget appBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(Home.screen.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      semanticChildCount: widget.feeds.length,
      controller: _scrollController,
      slivers: [
        appBar(context),
        MaterialSliverRefreshControl(
          onRefresh: () async {
            await widget.getFeeds(true);
            setState(() {});
          },
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          childCount: widget.feeds.length + 1,
          (BuildContext context, int index) {
            if (widget.feeds.length == index) {
              widget.getFeeds(false);
              return const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _build(widget.feeds[index]);
          },
        ))
      ],
    );
  }

  Widget _build(Feed feed) {
    Timeline line = Timeline(context, feed);
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: line.build(),
        ),
      ),
      const Divider(height: 0.5)
    ]);
  }
}
