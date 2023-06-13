import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/refresh/material.dart';
import 'package:flutter_bluesky/screen/parts/scroll/feed_scroll.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/screen/search/serach_line.dart';

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
            setState(() {});
          },
        ),
        sliverList
      ];

  Widget get appBar {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(background: searchBox()),
    );
  }

  @override
  Widget line(int index) {
    ProfileView actor = widget.manager.holder.actors[index];
    return Column(
        children: [SearchLine(actor: actor), const Divider(height: 0.5)]);
  }

  Widget searchBox({FormFieldValidator<String>? validator}) {
    return padding(TextFormField(
      scrollPadding: const EdgeInsets.all(0),
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0)),
          labelText: tr('Search'),
          prefixIcon: const Icon(Icons.search)),
      onChanged: (text) async {
        await manager.getData(false, term: controller.text);
        setState(() {
          controller.text = text;
        });
      },
      validator: validator,
    ));
  }
}
