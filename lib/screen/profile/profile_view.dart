import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/hyper_link.dart';
import 'package:flutter_bluesky/screen/parts/scroll/feed_scroll.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/parts/timeline/header.dart';

class ProfileView extends StatefulWidget {
  final ProfileDataManager manager;
  final BaseScreen baseScreen;

  const ProfileView({
    Key? key,
    required this.manager,
    required this.baseScreen,
  }) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with FeedScroll {
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
        SliverToBoxAdapter(
          child: header,
        ),
        sliverList
      ];

  Widget get header {
    return Column(
      children: [colorBox, info, const Divider(height: 0.5)],
    );
  }

  Widget get colorBox {
    return ColoredBox(
      color: Theme.of(context).colorScheme.primary,
      child: const SizedBox(
        height: 100,
        width: double.infinity,
      ),
    );
  }

  Widget get info {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: prof,
          ),
        ));
  }

  List<Widget> get prof {
    return [
      displayName(widget.manager.holder.detail, 28),
      handle(widget.manager.holder.detail),
      sizeBox,
      counts,
      sizeBox,
      HyperLink(widget.manager.holder.detail.description).withLink,
      sizeBox,
    ];
  }

  Widget get counts {
    return Row(
      children: [
        count(widget.manager.holder.detail.followersCount, 'followers'),
        sizeBox,
        count(widget.manager.holder.detail.followsCount, 'following'),
        sizeBox,
        count(widget.manager.holder.detail.postsCount, 'posts'),
      ],
    );
  }

  Widget count(int count, String postfix) {
    return Row(children: [
      bold(count),
      Text(postfix, style: const TextStyle(color: Colors.grey)),
    ]);
  }

  Widget bold(int count) {
    return Text(count.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold));
  }
}
