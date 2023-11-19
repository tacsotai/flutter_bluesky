import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/scroll/feed_scroll.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/profile/profile_content.dart';

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
    profileContent!.state = this;
    profileContent!.actor = widget.manager.holder.detail;
    profileContent!.specialActors = widget.manager.holder.specialActors;
    return page(context);
  }

  @override
  List<Widget> get slivers => [
        appBar,
        // SliverToBoxAdapter(
        //   child: profileContent!.header,
        // ),
        const SliverToBoxAdapter(
          child: Divider(height: 0.5),
        ),

        MaterialSliverRefreshControl(
          onRefresh: () async {
            await manager.getData(true);
            setState(() {});
          },
        ),
        sliverList
      ];

  // https://stackoverflow.com/questions/62446686/add-safearea-into-sliverappbar#62447962
  Widget get appBar {
    return SliverAppBar(
      floating: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 310, // TODO config
      flexibleSpace: FlexibleSpaceBar(
        background: SingleChildScrollView(child: profileContent!.header),
      ),
    );
  }

  @override
  Widget line(int index) {
    return timeline(index);
  }
}
