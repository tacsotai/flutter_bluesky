import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/home.dart';
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

  int selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 1:
        return search();
      default:
        return Home(bottom: bottom, hide: hide);
    }
  }

  Widget search() {
    return Scaffold(
      appBar: AppBar(), //TODO
      body: const Search(),
    );
  }

  Widget center() {
    return Center(child: Text("screen: $selectedIndex"));
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
                  });
                },
                type: BottomNavigationBarType.fixed,
                items: bottomNavigationBarItems(),
              ),
            );
          },
        ));
  }
}
