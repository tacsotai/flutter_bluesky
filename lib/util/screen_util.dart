import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/error.dart';
import 'package:flutter_bluesky/screen/home.dart';
import 'package:flutter_bluesky/screen/me.dart';
import 'package:flutter_bluesky/screen/notfifications.dart';
import 'package:flutter_bluesky/screen/provider.dart';
import 'package:flutter_bluesky/screen/search.dart';
import 'package:flutter_bluesky/util/session_manager.dart';

String initialRoute(BuildContext context) {
  if (isAlive) {
    SessionManager.get.checkSession(context);
    if (plugin.api.session.accessJwt != null) {
      return Base.route;
    } else {
      return LoginScreen.route;
    }
  } else {
    return Provider.screen.route;
  }
}

void pushBase(BuildContext context, {int selectedIndex = 0}) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    settings: RouteSettings(name: Base.route),
    builder: (context) => Base(selectedIndex: selectedIndex),
  ));
}

void pushLogin(BuildContext context) {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()));
  // return const Text("Provider is not settled");
}

void pushError(BuildContext context) {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ErrorScreen()));
  // return const Text("Provider is not settled");
}

ScreenUtil? screenUtil;

class ScreenUtil {
  final PluggableWidget home = Home();
  final PluggableWidget search = Search();
  final PluggableWidget notifications = Notifications();
  final PluggableWidget me = Me();

  Future<void> init() async {
    pluggables.add(home);
    pluggables.add(search);
    pluggables.add(notifications);
    pluggables.add(me);
    searchIndex = pluggables.indexOf(search);
    meIndex = pluggables.indexOf(me);
    await prepare();
  }

  Future<void> prepare() async {
    // for notification badge
    if (hasAccessToken && !expire) {
      await notifications.init();
    }
  }
}
