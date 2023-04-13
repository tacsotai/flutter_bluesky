import 'package:flutter_bluesky/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tuple/tuple.dart';

abstract class Atproto {
  final API api;
  Atproto({
    required this.api,
  });

  Future<Tuple2> describeServer() async {
    http.Response res = await api.get("com.atproto.server.describeServer");
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // Account Register and auto Login
  Future<Tuple2> createAccount(String email, String handle, String password,
      {String? inviteCode, String? recoveryKey}) async {
    // TODO format check for handle.
    http.Response res = await api.post("com.atproto.server.createAccount",
        headers: {"Content-Type": "application/json"},
        body: {"email": email, "handle": handle, "password": password});

    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // Login: id = email or handle
  Future<Tuple2> createSession(String identifier, String password) async {
    // TODO format check for handle.
    http.Response res = await api.post("com.atproto.server.createSession",
        headers: {"Content-Type": "application/json"},
        body: {"identifier": identifier, "password": password});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // Get User info
  Future<Tuple2> getSession() async {
    http.Response res = await api.get("com.atproto.server.getSession",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> refreshSession() async {
    http.Response res =
        await api.post("com.atproto.server.refreshSession", headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${api.session.refreshJwt}"
    }, body: {});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> createRecord(
      String repo, String collection, Map<String, dynamic> record) async {
    http.Response res =
        await api.post("com.atproto.server.createRecord", headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${api.session.accessJwt}"
    }, body: {
      "repo": repo,
      "collection": collection,
      "record": record
    });
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> listRecords(String collection, String repo) async {
    http.Response res = await api.get(
        "com.atproto.server.listRecords?collection=$collection&repo=$repo",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }
}
