import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/bluesky.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'flutter_bluesky_platform_interface.dart';

class FlutterBluesky extends Bluesky {
  FlutterBluesky({
    String? provider,
  }) : super(api: API(session: Session.create(provider: provider)));

  Future<String?> getPlatformVersion() {
    return FlutterBlueskyPlatform.instance.getPlatformVersion();
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

// app.bsky.actor.getProfile?actor=did:plc:u5xrfsqb6d2xrph6t4uwwe2h
// com.atproto.repo.listRecords?collection=app.bsky.graph.follow&repo=did:plc:qsanjuluxakgumuh6rjb25s3
// app.bsky.feed.getTimeline?algorithm=reverse-chronological&limit=30
// app.bsky.notification.listNotifications?limit=30
// app.bsky.graph.getFollows?actor=did:plc:u5xrfsqb6d2xrph6t4uwwe2h
// app.bsky.notification.getUnreadCount