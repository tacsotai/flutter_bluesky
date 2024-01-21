import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/notfifications.dart';
import 'package:tuple/tuple.dart';

ScreenUtil? screenUtil;

class ScreenUtil {
  static ScreenUtil get get {
    return screenUtil ?? ScreenUtil();
  }

  Future<Notifications> notifications() async {
    // for notification badge
    Notifications notifications = Notifications();
    if (hasSession) {
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
