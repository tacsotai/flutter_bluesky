// ignore_for_file: no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';

List<PluggableWidget> pluggables = [];

void initPluggables(Base base) {
  for (var pluggable in pluggables) {
    pluggable.setBase(base);
  }
}

class Base extends StatefulWidget {
  static String route = "/";
  final int selectedIndex;
  Base({Key? key, this.selectedIndex = 0}) : super(key: key);

  final BaseScreen screen = BaseScreen();

  @override
  BaseScreen createState() => screen;
}

class BaseScreen extends State<Base> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _height;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initPluggables(widget);
    _selectedIndex = widget.selectedIndex;
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
      return pluggables[_selectedIndex];
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
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
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
      list.add(pluggable.bottomNavigationBarItem);
    }
    return list;
  }
}
