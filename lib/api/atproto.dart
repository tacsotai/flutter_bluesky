// com.atproto.server.describeServer
// com.atproto.server.createAccount
// com.atproto.server.createSession
// com.atproto.server.getSession
// com.atproto.server.refreshSession
// com.atproto.repo.createRecord
// com.atproto.repo.listRecords?collection=app.bsky.graph.follow&repo=did:plc:u5xrfsqb6d2xrph6t4uwwe2h&reverse=true

import 'package:flutter_bluesky/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tuple/tuple.dart';

abstract class Atproto {
  final API api;
  Atproto({
    required this.api,
  });

  Future<int> describeServer() async {
    http.Response res = await api.get("com.atproto.server.describeServer");
    // TODO availableUserDomains
    return res.statusCode;
  }

  // Account Register and auto Login
  Future<Tuple2> createAccount(String email, String handle, String password,
      {String? inviteCode, String? recoveryKey}) async {
    // format check for handle.
    http.Response res = await api.post("com.atproto.server.createAccount",
        {"email": email, "handle": handle, "password": password});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // Login: id = email or handle
  Future<Tuple2> createSession(String identifier, String password) async {
    // format check for handle.
    http.Response res = await api.post("com.atproto.server.createSession",
        {"identifier": identifier, "password": password},
        headers: {"Content-Type": "application/json"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // Get User info
  Future<void> getSession() async {}

  // Postで呼ばれる
  Future<Map<String, String>> createRecord(
      String collection, String repo, Map post) async {
    return {};
  }

  // Record はTypeがUnknownなのでMapで持つことにする。
  Future<List<Map>> listRecords(String collection, String repo) async {
    return [];
  }
}
