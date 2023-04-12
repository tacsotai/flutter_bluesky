import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/bluesky.dart';
import 'package:flutter_bluesky/api/session.dart';

// This is a service class for atproto pds.
class FlutterBluesky extends Bluesky {
  FlutterBluesky({
    String? provider,
  }) : super(api: API(session: Session.create(provider: provider)));

  String getProvider() {
    return api.session.provider;
  }

  Future<bool> connect() async {
    return describeServer();
  }

  Future<void> register(String email, String handle, String password,
      {String? inviteCode}) async {
    createAccount(email, handle, password, inviteCode: inviteCode);
  }

  // id = email or handle
  Future<void> login(String emailORhandle, String password) async {
    createSession(emailORhandle, password);
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
