import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/Search.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/scroll/feed_scroll.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';

class SearchView extends StatefulWidget {
  final SearchDataManager manager;
  final BaseScreen baseScreen;

  const SearchView({
    Key? key,
    required this.manager,
    required this.baseScreen,
  }) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with FeedScroll {
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
            await manager.getData(true);
            setState(() {});
          },
        ),
        sliverList
      ];

  Widget get appBar {
    return SliverAppBar(
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(tr("Search")), // TODO なぜかTypeがSearch$となる。
      ),
    );
  }

  @override
  Widget line(int index) {
    return Text("hogehoge");
  }
}
