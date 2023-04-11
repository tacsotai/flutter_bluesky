import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/atproto.dart';
import 'package:flutter_bluesky/api/bluesky.dart';

import 'flutter_bluesky_platform_interface.dart';

var atproto = Atproto();
var bluesky = Bluesky();

class FlutterBluesky {
  Future<String?> getPlatformVersion() {
    return FlutterBlueskyPlatform.instance.getPlatformVersion();
  }

  Future<bool> connect(String url) async {
    // TODO implement
    return true;
  }

  Future<void> register(String email, String handle, String password,
      {String? inviteCode, String? recoveryKey}) async {
    atproto.createAccount(email, handle, password);
  }
}
