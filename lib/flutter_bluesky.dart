import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/bluesky.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/db.dart';
import 'package:tuple/tuple.dart';

// This is a service class for atproto pds.
class FlutterBluesky extends Bluesky {
  FlutterBluesky({
    String? provider,
  }) : super(api: API(session: Session.create(provider: provider)));

  String getProvider() {
    return api.session.provider;
  }

  Future<int> connect() async {
    return describeServer();
  }

  Future<int> register(String email, String handle, String password,
      {String? inviteCode}) async {
    Tuple2 res =
        await createAccount(email, handle, password, inviteCode: inviteCode);
    if (res.item1 == 200) {
      api.session.set(res.item2);
      await db.saveAccount(api.session.provider, email, password, res.item2);
    }
    return res.item1;
  }

  // id = email or handle
  Future<int> login(String emailORhandle, String password) async {
    Tuple2 res = await createSession(emailORhandle, password);
    if (res.item1 == 200) {
      api.session.set(res.item2);
      await db.saveAccount(
          api.session.provider, res.item2["email"], password, res.item2);
    } else {}
    return res.item1;
  }

  Future<Map> profile() async {
    return {};
  }

  Future<List> followees() async {
    return [];
  }

  Future<List> followers() async {
    return [];
  }

  Future<List> timeline() async {
    return [];
  }

  Future<int> noticeCount() async {
    return 0;
  }

  Future<List> notifications() async {
    return [];
  }
}
