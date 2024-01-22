import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:tuple/tuple.dart';

SessionManager? sessionManager;

bool get hasAccessToken {
  return isAlive && plugin.api.session.accessJwt != null;
}

void checkSession(BuildContext context) {
  plugin.getSession().then((res) => loginExpire(res, context));
}

void loginExpire(Tuple2 res, BuildContext context) {
  if (res.item1 != 200) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

class SessionManager {
  static SessionManager get get {
    return sessionManager ?? SessionManager();
  }

  Future<void> get restoreSession async {
    Map item = {};
    if (isAlive) {
      item = plugin.api.session.get;
    } else {
      for (MapEntry entry in Session.model.entries) {
        item = entry.value;
        setItem(item["provider"], item["key"]);
        break;
      }
    }
    if (item.isNotEmpty) {
      plugin.api.session.set(item);
      await plugin.sessionAPI.refresh();
    }
  }

  // TO BE OVER WRITE
  void setItem(String provider, String key) {
    setPlugin(FlutterBluesky(provider: provider, key: key));
  }
}
