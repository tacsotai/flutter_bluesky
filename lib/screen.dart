import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/post.dart';

Widget homeScreen(BuildContext context) {
  return const Base(); // TODO
}

void push(BuildContext context, String screenName) {
  Navigator.pushNamed(context, screenName);
}

Widget listsBody(List<Widget> widgets) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: widgets,
  );
}

mixin Frame {
  Widget scaffold(BuildContext context,
      {required Widget? bottom, required bool isPost, drawer}) {
    if (bottom == null) {
      return body();
    } else {
      return Scaffold(
        body: Stack(children: [
          body(),
          bottom,
        ]),
        floatingActionButton: floatingActionButton(context, isPost),
        drawer: drawer,
      );
    }
  }

  Widget? floatingActionButton(BuildContext context, bool isPost) {
    if (isPost) {
      return Container(
          padding: const EdgeInsets.only(bottom: 50), child: post(context));
    } else {
      return null;
    }
  }

  Widget body();

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
