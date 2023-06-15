import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/notfifications.dart';
import 'package:flutter_bluesky/screen/notifications/notification_line.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/scroll/feed_scroll.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/api/model/notification.dart' as notice;
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

class NotificationsView extends StatefulWidget {
  final NotificationsDataManager manager;
  final BaseScreen baseScreen;

  const NotificationsView({
    Key? key,
    required this.manager,
    required this.baseScreen,
  }) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> with FeedScroll {
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
          title: text(Notifications.screen.name, context), centerTitle: true),
    );
  }

  @override
  Widget line(int index) {
    notice.Notification notification =
        widget.manager.holder.notifications[index];
    return Column(children: [
      NotificationsLine(notification: notification),
      const Divider(height: 0.5)
    ]);
  }
}
