import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avatar.dart';
import 'package:flutter_bluesky/screen/parts/hyper_link.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/scroll/feed_scroll.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/profile/edit_profile.dart';

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
        MaterialSliverRefreshControl(
          onRefresh: () async {
            await manager.getData(true);
            setState(() {});
          },
        ),
        sliverList
      ];

  Widget get latestGetter {
    return MaterialSliverRefreshControl(
      onRefresh: () async {
        await manager.getData(true);
        setState(() {});
      },
    );
  }

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
    return Stack(alignment: AlignmentDirectional.bottomStart, children: [
      Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [banner, padding(profEditButton, top: 5, bottom: 5)]),
      padding(profAvatar)
    ]);
  }

  Widget get profAvatar {
    return avatar(context, plugin.api.session.actor!.avatar,
        radius: 45, func: showAvatarPicture);
  }

  void showAvatarPicture() {
    // TODO show picture
  }

  // TODO show picture
  Widget get banner {
    return ColoredBox(
      color: Theme.of(context).colorScheme.primary,
      child: const SizedBox(
        height: 150,
        width: double.infinity,
      ),
    );
  }

  Widget get displayNameDescription {
    String desc = widget.manager.holder.detail.description ?? "";
    Widget description = HyperLink(desc).withLink;
    return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayName(widget.manager.holder.detail, 28),
              handle(widget.manager.holder.detail),
              counts,
              description,
            ],
          ),
        ));
  }

  Widget get profEditButton {
    return ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, EditProfile.screen.route),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ))),
        child: Text(tr("profile.edit")));
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
