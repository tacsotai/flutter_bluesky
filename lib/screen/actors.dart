import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/actors/actors_view.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/data/factory.dart';
import 'package:flutter_bluesky/screen/data/manager.dart';
import 'package:flutter_bluesky/util/session_manager.dart';

// followings, followers, and so on.
class Actors extends StatefulWidget {
  static Screen screen = Screen(Actors, const Icon(Icons.group));
  final String? prop;
  final String? actor;
  const Actors({Key? key, this.actor, this.prop}) : super(key: key);

  @override
  ActorsScreen createState() => ActorsScreen();
}

class ActorsScreen extends State<Actors> {
  @override
  Widget build(BuildContext context) {
    checkSession(context);
    base!.screen.byOutside = true;
    return Scaffold(
      body: Stack(children: [
        _build(),
        base!.screen.bottom,
      ]),
    );
  }

  Widget _build() {
    ActorsDataManager manager =
        managerFactory!.getActorsDataManager(widget.prop!);
    return FutureBuilder(
        future: manager.getData(false, term: widget.actor),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return ActorsView(
              prop: widget.prop!,
              manager: manager,
              baseScreen: Base().screen,
            );
          }
        });
  }
}
