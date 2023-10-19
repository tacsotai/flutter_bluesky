import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/session_api.dart';
import 'package:http/http.dart' as http;

// This class refresh session if the accessJwt is expired.
class RefreshAPI extends API {
  static String refreshURI = "com.atproto.server.refreshSession";
  RefreshAPI({required super.session});

  bool isRefresh(String uri, Map<String, String>? headers, http.Response res) {
    return (uri != refreshURI &&
        res.statusCode != 200 &&
        json.decode(res.body)["error"] == "ExpiredToken" &&
        headers != null &&
        headers["Authorization"] != null);
  }

  @override
  Future<http.Response> get(String uri,
      {Map<String, String>? headers, Map<String, dynamic>? params}) async {
    http.Response res = await super.get(uri, headers: headers, params: params);
    if (isRefresh(uri, headers, res)) {
      debugPrint(res.body);
      await SessionAPI(api: this).refresh();
      return await super.get(uri, headers: headers, params: params);
    }
    return res;
  }

  @override
  Future<http.Response> post(String uri,
      {required Map<String, String> headers, Object? body}) async {
    http.Response res = await super.post(uri, headers: headers, body: body);
    if (isRefresh(uri, headers, res)) {
      await SessionAPI(api: this).refresh();
      return await super.post(uri, headers: headers, body: body);
    }
    return res;
  }
}
