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

  late DataManager manager;
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
      semanticChildCount: manager.length,
      controller: scrollController,
      slivers: slivers,
    );
  }

  List<Widget> get slivers;

  SliverList get sliverList {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      childCount: manager.length + 1,
      (BuildContext context, int index) {
        if (manager.length == index) {
          if (isLoading) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Container();
        }
        return line(index);
      },
    ));
  }

  Widget line(int index);

  // for home and profile
  Widget timeline(int index) {
    Timeline line =
        Timeline((manager as FeedDataManager).feedHolder.feeds[index]);
    return outline(line);
  }
}
