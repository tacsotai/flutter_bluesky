import 'package:flutter_bluesky/api/atproto.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// https://github.com/bluesky-social/atproto/tree/main/lexicons
abstract class Bluesky extends Atproto {
  Bluesky({required super.api});

  Future<Tuple2> getProfile(String actor) async {
    http.Response res = await api.get("app.bsky.actor.getProfile",
        params: {"actor": actor},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getSuggestions({int? limit, String? cursor}) async {
    http.Response res = await api.get("app.bsky.actor.getSuggestions",
        params: {"limit": limit, "cursor": cursor},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> searchActors(
      {String? term, int? limit, String? cursor}) async {
    http.Response res = await api.get("app.bsky.actor.searchActors",
        params: {"term": term, "limit": limit, "cursor": cursor},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> searchActorsTypeahead({String? term, int? limit}) async {
    http.Response res = await api.get("app.bsky.actor.searchActorsTypeahead",
        params: {"term": term, "limit": limit},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getAuthorFeed(String actor,
      {int? limit, String? cursor}) async {
    http.Response res = await api.get("app.bsky.feed.getAuthorFeed",
        params: {"actor": actor, "limit": limit, "cursor": cursor},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // uris should be uris[]=at..&uris[]=at..uris[]=at.. ...
  Future<Tuple2> getPosts(String uris) async {
    http.Response res = await api.get("app.bsky.feed.getPosts",
        params: {"uris[]": uris},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getTimeline(
      {String? algorithm, int? limit, String? cursor}) async {
    http.Response res = await api.get("app.bsky.feed.getTimeline",
        params: {"algorithm": algorithm, "limit": limit, "cursor": cursor},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getPostThread(String uri,
      {int? depth, int? parentHeight}) async {
    http.Response res = await api.get("app.bsky.feed.getPostThread",
        params: {"uri": uri, "depth": depth, "parentHeight": parentHeight},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // lexicons/app/bsky/graph/getFollowers.json
  Future<Tuple2> getFollows(String actor, {int? limit, String? cursor}) async {
    http.Response res = await api.get("app.bsky.graph.getFollows",
        params: {"actor": actor, "limit": limit, "cursor": cursor},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> getUnreadCount({String? seenAt}) async {
    http.Response res = await api.get("app.bsky.notification.getUnreadCount",
        params: {"seenAt": seenAt},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> listNotifications(
      {int? limit, String? cursor, String? seenAt}) async {
    http.Response res = await api.get("app.bsky.notification.listNotifications",
        params: {"limit": limit, "cursor": cursor, "seenAt": seenAt},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> updateSeen(String seenAt) async {
    Map<String, dynamic> params = {
      "seenAt": seenAt,
    };
    http.Response res = await api.post("app.bsky.notification.updateSeen",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${api.session.accessJwt}"
        },
        body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }
}
