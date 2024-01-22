import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/api/session.dart';

SessionManager? sessionManager;

bool get hasAccessToken {
  return isAlive && plugin.api.session.accessJwt != null;
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
