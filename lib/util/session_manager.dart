// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';
import 'package:flutter_bluesky/util/screen_util.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tuple/tuple.dart';

bool get hasAccessToken {
  return isAlive && plugin.api.session.accessJwt != null;
}

bool get expire {
  Map<String, dynamic> decodedToken =
      JwtDecoder.decode(plugin.api.session.accessJwt!);
  return DateTime.now().isAfter(dt(decodedToken["exp"]));
}

Future<void> checkSession(BuildContext context) async {
  try {
    if (hasAccessToken && expire) {
      await plugin.sessionAPI.refresh();
      Tuple2 res = await plugin.getSession();
      if (res.item1 != 200) {
        pushLogin(context);
      }
    }
  } catch (e) {
    pushError(context);
  }
}
