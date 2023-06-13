import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/avatar.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

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
      Avatar(context).net(widget.actor).profile
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
    return Text(actor.displayName ?? actor.handle);
  }
}
