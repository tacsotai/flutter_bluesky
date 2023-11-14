import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/scroll/feed_scroll.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/search/actor_line.dart';

class ActorsView extends StatefulWidget {
  final String prop;
  final ActorsDataManager manager;
  final BaseScreen baseScreen;

  const ActorsView({
    Key? key,
    required this.prop,
    required this.manager,
    required this.baseScreen,
  }) : super(key: key);

  @override
  State<ActorsView> createState() => _ActorsViewState();
}

class _ActorsViewState extends State<ActorsView> with FeedScroll {
  final TextEditingController controller = TextEditingController();

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
            // domain, text, and so on
            await manager.getData(true, term: controller.text);
          },
        ),
        sliverList
      ];

  Widget get appBar {
    return SliverAppBar(
      pinned: true, // #90 Don't use state() and isLoding for onRefresh:
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(tr(widget.prop)),
          titlePadding: const EdgeInsetsDirectional.only(start: 70)),
    );
  }

  @override
  Widget line(int index) {
    ProfileView actor = widget.manager.holder.actors[index];
    return Column(
        children: [ActorLine(actor: actor), const Divider(height: 0.5)]);
  }
}
