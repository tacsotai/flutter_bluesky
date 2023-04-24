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
  const Home({Key? key}) : super(key: key);
  static Screen screen = Screen(Home, const Icon(Icons.home));

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with Base, SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _height;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {});

    _height = Tween<double>(begin: 0, end: 100).animate(_animationController);
  }

  void hide(bool flg) {
    if (flg) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
      floatingActionButton: Container(
          // margin: const EdgeInsets.only(bottom: 70),
          padding: const EdgeInsets.only(bottom: 50),
          child: post(context)),
    );
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

  Widget body(BuildContext context) {
    return FutureBuilder(
      future: getFeeds(false),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return Stack(children: [
            InfinityListView(
              feeds: feeds,
              getFeeds: getFeeds,
              hide: hide,
            ),
            bottom(),
          ]);
        }
      },
    );
  }

  Widget bottom() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: AnimatedBuilder(
          animation: _height,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
              offset: Offset(0, _height.value),
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                items: bottomNavigationBarItems(),
              ),
            );
          },
        ));
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
