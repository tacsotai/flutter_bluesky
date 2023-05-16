import 'package:flutter_bluesky/screen/parts/timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

mixin FeedScroll {
  late ScrollController scrollController;
  bool isHidden = false;
  bool isLoading = false;

  late FeedDataManager manager;
  late BaseScreen baseScreen;

  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isHidden) {
          baseScreen.hideBottom(true);
          isHidden = true;
        }
      } else {
        if (isHidden) {
          baseScreen.hideBottom(false);
          isHidden = false;
        }
      }
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading) {
        isLoading = true;

        await manager.getData(false);

        state();
      }
    });
  }

  void state();

  Widget page(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      semanticChildCount: manager.feedHolder.feeds.length,
      controller: scrollController,
      slivers: slivers,
    );
  }

  List<Widget> get slivers;

  SliverList get sliverList {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      childCount: manager.feedHolder.feeds.length + 1,
      (BuildContext context, int index) {
        if (manager.feedHolder.feeds.length == index) {
          manager.getData(false);
          return const SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return line(index);
      },
    ));
  }

  Widget line(int index) {
    Timeline line = Timeline(manager.feedHolder.feeds[index]);
    return outline(line);
  }
}
