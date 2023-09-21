import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'dart:convert';

// This class has API for session between Atproto and Bluesky
class SessionAPI {
  final API api;
  SessionAPI({
    required this.api,
  });

  Future<Tuple2> refreshSession() async {
    http.Response res = await api.post("com.atproto.server.refreshSession",
        headers: {"Authorization": "Bearer ${api.session.refreshJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> deleteSession() async {
    http.Response res = await api.post(
      "com.atproto.server.deleteSession",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${api.session.accessJwt}"
      },
    );
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getSession() async {
    http.Response res = await api.get("com.atproto.server.getSession",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getProfile(String actor) async {
    http.Response res = await api.get("app.bsky.actor.getProfile",
        params: {"actor": actor},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<void> refresh() async {
    Tuple2 res = await refreshSession();
    if (res.item1 == 200) {
      resessiion(res);
      await profile();
    }
  }

  Future<void> resessiion(Tuple2 res) async {
    api.session.accessJwt = res.item2["accessJwt"];
    Tuple2 res2 = await getSession();
    res.item2["email"] = res2.item2["email"];
    api.session.set(res.item2);
  }

  // actor = null after login
  Future<void> profile() async {
    Tuple2 res = await getProfile(api.session.did!);
    if (res.item1 == 200) {
      api.session.actor = ProfileViewDetailed(res.item2);
    }
  }
}
