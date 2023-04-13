import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/bluesky.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/db.dart';
import 'package:tuple/tuple.dart';

// This is a service class for atproto pds.
class FlutterBluesky extends Bluesky {
  Map serverDescription = {};

  FlutterBluesky({
    String? provider,
  }) : super(api: API(session: Session.create(provider: provider)));

  String getProvider() {
    return api.session.provider;
  }

  Future<Tuple2> connect() async {
    Tuple2 res = await describeServer();
    serverDescription = res.item2;
    return res;
  }

  bool inviteCodeRequired() {
    return serverDescription["inviteCodeRequired"];
  }

  bool availableUserDomain(String handle) {
    for (var domain in serverDescription["availableUserDomains"]) {
      if (handle.endsWith(domain)) {
        return true;
      }
    }
    return false;
  }

  // Invoked after availableUserDomain, otherwise this API retuen error.
  Future<Tuple2> register(String email, String handle, String password,
      {String? inviteCode}) async {
    Tuple2 res =
        await createAccount(email, handle, password, inviteCode: inviteCode);
    if (res.item1 == 200 || res.item1 == 201) {
      api.session.set(res.item2);
      await db.saveAccount(api.session.provider, email, password, res.item2);
    }
    return res;
  }

  // id = email or handle
  Future<Tuple2> login(String emailORhandle, String password) async {
    Tuple2 res = await createSession(emailORhandle, password);
    if (res.item1 == 200) {
      api.session.set(res.item2);
      await db.saveAccount(
          api.session.provider, res.item2["email"], password, res.item2);
    }
    return res;
  }

  // Future<Map> profile() async {
  //   return {};
  // }

  // Future<List> followees() async {
  //   return [];
  // }

  // Future<List> followers() async {
  //   return [];
  // }

  Future<List> timeline() async {
    return [];
  }

  // Future<int> noticeCount() async {
  //   return 0;
  // }

  // Future<List> notifications() async {
  //   return [];
  // }
}
