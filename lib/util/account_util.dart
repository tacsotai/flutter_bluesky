import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

bool isLoginUser(ProfileViewBasic actor) {
  return actor.did == plugin.api.session.actor!.did;
}

bool _useDomain = true;

void notShowDomain() {
  _useDomain = false;
}

// see Header
String getAccount(String handle) {
  if (_useDomain) {
    return handle;
  }
  return withoutDomain(handle);
}
