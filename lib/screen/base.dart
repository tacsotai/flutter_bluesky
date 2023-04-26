// ignore_for_file: no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';

final Base base = Base();

class Base extends StatefulWidget {
  static String route = "/";
  final List<PluggableWidget> pluggables = [];

  Base({Key? key}) : super(key: key);

  final BaseScreen screen = BaseScreen();

  @override
  BaseScreen createState() => screen;
}

class BaseScreen extends State<Base> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _height;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {});

    _height = Tween<double>(begin: 0, end: 100).animate(_animationController);
  }

  void hideBottom(bool flg) {
    if (flg) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.pluggables[_selectedIndex];
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
    for (var pluggable in widget.pluggables) {
      list.add(pluggable.bottomNavigationBarItem);
    }
    return list;
  }
}
