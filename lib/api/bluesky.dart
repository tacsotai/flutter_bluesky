import 'package:flutter_bluesky/api/atproto.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class Bluesky extends Atproto {
  Bluesky({required super.api});

  Future<Tuple2> getProfile(String actor) async {
    http.Response res = await api.get("app.bsky.actor.getProfile?actor=$actor",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getSuggestions(int limit) async {
    http.Response res = await api.get(
        "app.bsky.actor.getSuggestions?limit=$limit",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getAuthorFeed(int limit, String actor,
      {String? cursor}) async {
    String uri = "app.bsky.actor.getAuthorFeed?limit=$limit&actor=$actor";
    if (cursor != null) {
      uri = "$uri&cursor=$cursor";
    }
    http.Response res = await api.get(uri,
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getTimeline(int limit, String algorithm) async {
    http.Response res = await api.get(
        "app.bsky.actor.getTimeline?algorithm=$algorithm&limit=$limit",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getPostThread(String uri) async {
    http.Response res = await api.get("app.bsky.actor.getPostThread?uri=$uri",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getFollows(String actor) async {
    http.Response res = await api.get("app.bsky.actor.getFollows?actor=$actor",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getUnreadCount() async {
    http.Response res = await api.get("app.bsky.actor.getUnreadCount",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> listNotifications(int limit) async {
    http.Response res = await api.get(
        "app.bsky.actor.listNotifications?limit=$limit",
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }
}
