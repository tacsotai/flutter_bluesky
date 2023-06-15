import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avatar.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';
import 'package:flutter_bluesky/screen/parts/button/button_manager.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/screen/profile.dart';
import 'package:tuple/tuple.dart';

SearchContent? customSearchContent;

class SearchLine extends StatefulWidget {
  final ProfileView actor;
  const SearchLine({Key? key, required this.actor}) : super(key: key);
  @override
  SearchLineScreen createState() => SearchLineScreen();
}

class SearchLineScreen extends State<SearchLine> {
  @override
  Widget build(BuildContext context) {
    return padding(paddingLR([
      Avatar(context, radius: 25).net(widget.actor).profile
    ], [
      contet,
    ]));
  }

  Widget get contet {
    SearchContent sc = customSearchContent ?? SearchContent();
    return sc.build(this, widget.actor);
  }
}

class SearchContent {
  Widget build(State state, ProfileView actor) {
    Widget left = displayNameHandle(actor);
    FollowButton button =
        buttonManager!.followButton(state, actor) as FollowButton;
    Widget right = button.isFollowing ? Container() : button.widget;
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lr(left, right, const Tuple2(5, 4)),
          description(actor),
        ],
      ),
      onTap: () async {
        Navigator.push(
          state.context,
          MaterialPageRoute(builder: (context) => Profile(user: actor.did)),
        );
      },
    );
  }
}
