import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/error.dart';
import 'package:flutter_bluesky/screen/notfifications.dart';
import 'package:flutter_bluesky/screen/provider.dart';
import 'package:flutter_bluesky/util/session_manager.dart';
import 'package:tuple/tuple.dart';

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
  static ScreenUtil get get {
    return screenUtil ?? ScreenUtil();
  }

  Future<Notifications> notifications() async {
    // for notification badge
    Notifications notifications = Notifications();
    if (hasAccessToken) {
      Tuple2 res = await plugin.getSession();
      if (res.item1 == 200) {
        await notifications.init();
      } else {
        plugin.api.session.remove();
      }
    }
    return notifications;
  }
}
