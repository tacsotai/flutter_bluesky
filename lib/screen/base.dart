import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/home.dart';
import 'package:flutter_bluesky/screen/notfifications.dart';
import 'package:flutter_bluesky/screen/profile.dart';
import 'package:flutter_bluesky/screen/search.dart';

class Base extends StatefulWidget {
  static String route = "/";
  const Base({Key? key}) : super(key: key);

  @override
  BaseScreen createState() => BaseScreen();
}

class BaseScreen extends State<Base>
    with Frame, SingleTickerProviderStateMixin {
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

  void hide(bool flg) {
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
    switch (_selectedIndex) {
      case 0:
        return Home(bottom: bottom, hide: hide);
      case 1:
        return Search(bottom: bottom, hide: hide);
      case 2:
        return Notifications(bottom: bottom, hide: hide);
      case 3:
        return Profile(bottom: bottom, hide: hide);
      default:
        return Home(bottom: bottom, hide: hide);
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
                items: [
                  _bottomNavigationBarItem(Home.screen),
                  _bottomNavigationBarItem(Search.screen),
                  _bottomNavigationBarItem(Notifications.screen),
                  _bottomNavigationBarItem(Profile.screen),
                ],
              ),
            );
          },
        ));
  }

  BottomNavigationBarItem _bottomNavigationBarItem(Screen screen) {
    return BottomNavigationBarItem(
      icon: screen.icon,
      label: tr(screen.name),
      tooltip: tr(screen.name),
    );
  }
}
