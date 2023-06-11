import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avatar.dart';
import 'package:flutter_bluesky/screen/parts/button/button_manager.dart';
import 'package:flutter_bluesky/screen/parts/hyper_link.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/scroll/feed_scroll.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/parts/banner.dart' as prof;

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
  late ProfileViewDetailed actor;
  @override
  void initState() {
    actor = widget.manager.holder.detail;
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
        MaterialSliverRefreshControl(
          onRefresh: () async {
            await manager.getData(true);
            setState(() {});
          },
        ),
        sliverList
      ];

  Widget get header {
    return Column(
      children: [
        bannerAvatar,
        displayNameDescription,
        const Divider(height: 0.5)
      ],
    );
  }

  Widget get bannerAvatar {
    Widget button = buttonManager!.profileViewButton(this, actor).widget;
    return Stack(alignment: AlignmentDirectional.bottomStart, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        banner,
        const Divider(height: 0.5),
        padding(button, top: 5, bottom: 5)
      ]),
      padding(profAvatar)
    ]);
  }

  Widget get profAvatar {
    return Avatar(context, radius: 45).net(actor).profile;
  }

  Widget get banner {
    return prof.Banner(context).net(actor).banner;
  }

  Widget get displayNameDescription {
    String desc = actor.description ?? "";
    Widget description = HyperLink(desc).withLink;
    return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayName(actor, 28),
              handle(actor),
              counts,
              description,
            ],
          ),
        ));
  }

  Widget get counts {
    return Row(
      children: [
        count(actor.followersCount, 'followers'),
        sizeBox,
        count(actor.followsCount, 'following'),
        sizeBox,
        count(actor.postsCount, 'posts'),
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

  @override
  Widget line(int index) {
    return timeline(index);
  }
}
