import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/notfifications.dart';
import 'package:flutter_bluesky/screen/provider.dart';
import 'package:flutter_bluesky/util/session_manager.dart';
import 'package:tuple/tuple.dart';

String initialRoute(BuildContext context) {
  if (isAlive) {
    if (plugin.api.session.accessJwt != null) {
      return Base.route;
    } else {
      return LoginScreen.route;
    }
  } else {
    return Provider.screen.route;
  }
}

void loginExpire(BuildContext context) {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()));
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
