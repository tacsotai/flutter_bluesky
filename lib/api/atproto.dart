// com.atproto.server.describeServer
// com.atproto.server.createAccount
// com.atproto.server.createSession
// com.atproto.server.getSession
// com.atproto.server.refreshSession
// com.atproto.repo.createRecord
// com.atproto.repo.listRecords?collection=app.bsky.graph.follow&repo=did:plc:u5xrfsqb6d2xrph6t4uwwe2h&reverse=true

import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/data/model/post.dart';
import 'package:flutter_bluesky/data/model/user/account.dart';

class Atproto {
  String? provider;

  // provider https://hoge.jp/foo/
  Future<bool> describeServer(String provider) async {
    return true;
  }

  // Account Register and auto Login
  Future<void> createAccount(String email, String handle, String password,
      {String? inviteCode, String? recoveryKey}) async {
    // format check for handle.
  }

  // Login: id = email or handle
  Future<void> createSession(String id, String password) async {}

  // Get User info
  Future<void> getSession() async {}

  // Postで呼ばれる
  Future<Map<String, String>> createRecord(
      String collection, String repo, Post post) async {
    return {};
  }

  // Record はTypeがUnknownなのでMapで持つことにする。
  Future<List<Map>> listRecords(String collection, String repo) async {
    return [];
  }
}
