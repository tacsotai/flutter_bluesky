import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/base.dart';

abstract class PluggableWidget extends StatefulWidget {
  const PluggableWidget({super.key});

  BottomNavigationBarItem get bottomNavigationBarItem;

  BottomNavigationBarItem navi(Screen screen) {
    return BottomNavigationBarItem(
      icon: screen.icon,
      label: tr(screen.name),
      tooltip: tr(screen.name),
    );
  }

  Future<void> init() async {
    // Do nothing by default.
  }

  void setBase(Base base);
}

mixin Frame {
  Widget scaffold(BuildContext context,
      {required Widget? bottom, required FloatingActionButton? fab, drawer}) {
    if (bottom == null) {
      return body();
    } else {
      return Scaffold(
        body: Stack(children: [
          body(),
          bottom,
        ]),
        floatingActionButton: adjustPosition(fab),
        drawer: drawer,
      );
    }
  }

  Widget? adjustPosition(FloatingActionButton? button) {
    return button == null
        ? null
        : Container(padding: const EdgeInsets.only(bottom: 50), child: button);
  }

  Widget body();
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
