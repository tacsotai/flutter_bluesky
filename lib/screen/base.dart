import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/util/base_util.dart';
import 'package:flutter_bluesky/util/session_manager.dart';

List<PluggableWidget> pluggables = [];

/// It will be access [BaseScreen.byOutside]
Base? base;

void initPluggables(Base baseWidget) {
  base = baseWidget;
  for (var pluggable in pluggables) {
    pluggable.setBase(baseWidget);
  }
}

class Base extends StatefulWidget {
  static String route = "/";
  final int selectedIndex;
  Base({Key? key, this.selectedIndex = 0}) : super(key: key);

  final BaseScreen screen = BaseScreen();

  @override
  // ignore: no_logic_in_create_state
  BaseScreen createState() => screen;
}

class BaseScreen extends State<Base> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _height;

  int selectedIndex = 0;

  /// Base widget is used by [PluggableWidget]; in this case false.
  /// If Other use this class, it will be true.
  bool byOutside = false;

  @override
  void initState() {
    super.initState();
    initPluggables(widget);
    selectedIndex = widget.selectedIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {});

    _height = Tween<double>(begin: 0, end: 100).animate(_animationController);
  }

  void hideBottom(bool flg) {
    try {
      if (flg) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    } catch (e) {
      // Do nothing for linked profile page #86
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasSession) {
      checkSession(context);
      return pluggables[selectedIndex];
    } else {
      return const Text("Provider is not settled");
    }
  }

  Widget get bottom {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: AnimatedBuilder(
          animation: _height,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
              offset: Offset(0, _height.value),
              child: BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                    // debugPrint("fromOutside: $byOutside");
                    // debugPrint("index: $index");
                    if (byOutside) {
                      pushBase(context, selectedIndex: selectedIndex);
                    }
                  });
                },
                type: BottomNavigationBarType.fixed,
                items: _bottomNavigationBarItems,
              ),
            );
          },
        ));
  }

  List<BottomNavigationBarItem> get _bottomNavigationBarItems {
    List<BottomNavigationBarItem> list = [];
    for (var pluggable in pluggables) {
      pluggable.init();
      list.add(pluggable.bottomNavigationBarItem);
    }
    return list;
  }
}
