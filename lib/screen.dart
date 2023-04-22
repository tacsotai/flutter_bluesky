import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/notfifications.dart';
import 'package:flutter_bluesky/screen/profile.dart';
import 'package:flutter_bluesky/screen/search.dart';
import 'package:flutter_bluesky/screen/home.dart';
import 'package:flutter_bluesky/screen/post.dart';
import 'package:easy_localization/easy_localization.dart';

Widget homeScreen(BuildContext context) {
  return const Home();
}

void push(BuildContext context, String screenName) {
  Navigator.pushNamed(context, screenName);
}

mixin Base {
  Widget listsBody(List<Widget> widgets) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  Widget post(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        push(context, Post.screen.route);
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(
        Icons.edit,
        size: 30,
      ),
    );
  }

  Widget menu(BuildContext context) {
    return BottomAppBar(
      // shape: shape
      color: Theme.of(context).colorScheme.onPrimary,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.primary),
        child: Row(
          children: <Widget>[
            _link(context, Home.screen),
            const Spacer(),
            _link(context, Search.screen),
            const Spacer(),
            _link(context, Notifications.screen),
            const Spacer(),
            _link(context, Profile.screen),
          ],
        ),
      ),
    );
  }

  IconButton _link(BuildContext context, Screen screen) {
    return IconButton(
      iconSize: 35,
      tooltip: tr(screen.name),
      icon: screen.icon,
      onPressed: () {
        push(context, screen.route);
      },
    );
  }

  List<BottomNavigationBarItem> bottomNavigationBarItems() {
    return [
      bottomNavigationBarItem(Home.screen),
      bottomNavigationBarItem(Search.screen),
      bottomNavigationBarItem(Notifications.screen),
      bottomNavigationBarItem(Profile.screen),
    ];
  }

  BottomNavigationBarItem bottomNavigationBarItem(Screen screen) {
    return BottomNavigationBarItem(
      icon: screen.icon,
      label: tr(screen.name),
      tooltip: tr(screen.name),
    );
  }
}

class Screen {
  final Type type;
  final String name;
  final String route;
  final Icon icon;

  Screen(this.type, this.icon)
      : name = type.toString(),
        route = "/${type.toString().toLowerCase()}";
}
