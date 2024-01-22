import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';
import 'package:flutter_bluesky/util/screen_util.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tuple/tuple.dart';

SessionManager? sessionManager;

bool get hasAccessToken {
  return isAlive && plugin.api.session.accessJwt != null;
}

bool get expire {
  Map<String, dynamic> decodedToken =
      JwtDecoder.decode(plugin.api.session.accessJwt!);
  return dt(decodedToken["exp"]).isAfter(DateTime.now());
}

class SessionManager {
  static SessionManager get get {
    return sessionManager ?? SessionManager();
  }

  Future<void> checkSession(BuildContext context) async {
    try {
      if (hasAccessToken && expire) {
        await plugin.sessionAPI.refresh();
        Tuple2 res = await plugin.getSession();
        if (res.item1 != 200) {
          // ignore: use_build_context_synchronously
          pushLogin(context);
        }
      }
    } catch (e) {
      // #213
      // client exception
      // navigate to maintenace screen
    }
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
