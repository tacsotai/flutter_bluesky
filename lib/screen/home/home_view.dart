import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/scroll/feed_scroll.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

class HomeView extends StatefulWidget {
  final HomeDataManager manager;
  final BaseScreen baseScreen;

  const HomeView({
    Key? key,
    required this.manager,
    required this.baseScreen,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with FeedScroll {
  @override
  void initState() {
    super.manager = widget.manager;
    super.baseScreen = widget.baseScreen;
    super.initState();
  }

  @override
  void state() {
    setState(() {
      super.isLoading = false;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return page(context);
  }

  @override
  List<Widget> get slivers => [
        appBar,
        MaterialSliverRefreshControl(
          onRefresh: () async {
            isLoading = true;
            await manager.getData(true);
            state();
          },
        ),
        sliverList
      ];

  Widget get appBar {
    return SliverAppBar(
      floating: true,
      flexibleSpace:
          FlexibleSpaceBar(title: text('title', context), centerTitle: true),
    );
  }

  @override
  Widget line(int index) {
    return timeline(index);
  }
}
