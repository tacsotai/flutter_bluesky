// com.atproto.server.describeServer
// com.atproto.server.createAccount
// com.atproto.server.createSession
// com.atproto.server.getSession
// com.atproto.server.refreshSession
// com.atproto.repo.createRecord
// com.atproto.repo.listRecords?collection=app.bsky.graph.follow&repo=did:plc:u5xrfsqb6d2xrph6t4uwwe2h&reverse=true

import 'package:flutter_bluesky/data/model/post.dart';
import 'package:flutter_bluesky/data/model/session.dart';

class Atproto {
  // keep-alive
  Future<bool> describeServer() async {
    return true;
  }

  // Account Register and auto Login
  Future<Session> createAccount(String email, String handle, String password,
      {String? inviteCode, String? recoveryKey}) async {
    // format check for handle.
    return Session(
      handle: "handle",
      did: "did",
      accessJwt: "accessJwt",
      refreshJwt: "refreshJwt",
    );
  }

  // Login: id = email or handle
  Future<Session> createSession(String id, String password) async {
    return Session(
      handle: "handle",
      did: "did",
      email: "email",
      accessJwt: "accessJwt",
      refreshJwt: "refreshJwt",
    );
  }

  // Get User info
  Future<Session> getSession() async {
    return Session(
      handle: "handle",
      did: "did",
      email: "email",
    );
  }

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
