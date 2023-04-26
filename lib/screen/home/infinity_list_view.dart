import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/home.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/timeline.dart';
import 'package:flutter_bluesky/api/model/feed.dart';
import 'package:flutter/rendering.dart';

class InfinityListView extends StatefulWidget {
  final List<Feed> feeds;
  final Future<void> Function(bool) getFeeds;
  final BaseScreen baseScreen;

  const InfinityListView({
    Key? key,
    required this.feeds,
    required this.getFeeds,
    required this.baseScreen,
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
          widget.baseScreen.hideBottom(true);
          isHidden = true;
        }
      } else {
        if (isHidden) {
          widget.baseScreen.hideBottom(false);
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
        title: Text(Home.screen.name), // TODO each screen name.
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
