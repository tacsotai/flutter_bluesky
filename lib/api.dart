import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/session.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// discard API when use another provider.
class API {
  final Session session;
  API({
    required this.session,
  });

  Future<http.Response> get(String uri, {Map<String, String>? headers}) async {
    Uri url = _uri(uri);
    debugPrint('url: ${url.toString()}');
    debugPrint("headers: $headers");
    http.Response res = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 5)); // TODO asset config
    return res;
  }

  Future<http.Response> post(String uri,
      {required Map<String, String> headers,
      Map<String, dynamic>? body}) async {
    Uri url = _uri(uri);
    headers["Content-Type"] = "application/json";
    debugPrint('body: $body');
    debugPrint("headers: $headers");
    debugPrint('url: ${url.toString()}');
    http.Response res = await http
        .post(url, headers: headers, body: json.encode(body))
        .timeout(const Duration(seconds: 5)); // TODO asset config
    return res;
  }

  Uri _uri(String uri) {
    return Uri.parse("${session.provider}/$xrpc/$uri");
  }
}
