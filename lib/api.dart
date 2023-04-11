import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/exception.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

const JsonEncoder encoder = JsonEncoder();

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
        .get(url)
        .timeout(const Duration(seconds: 5)); // TODO asset config
    if (res.statusCode == 200 || res.statusCode == 304) {
      return res;
    } else {
      throw APIGetException(url, headers, res);
    }
  }

  Future<http.Response> post(String uri, Map<String, String>? headers,
      Map<String, dynamic> body) async {
    Uri url = _uri(uri);
    debugPrint('body: $body');
    debugPrint("headers: $headers");
    debugPrint('url: ${uri.toString()}');
    http.Response res = await http
        .post(url, headers: headers, body: json.encode(body))
        .timeout(const Duration(seconds: 5)); // TODO asset config
    if (res.statusCode == 200 || res.statusCode == 201) {
      return res;
    } else {
      throw APIPostException(url, headers, body, res);
    }
  }

  Uri _uri(String uri) {
    return Uri.parse("${session.provider}/$xrpc/$uri");
  }

  // Future<String> _post(Map<String, dynamic> body) async {
  //   Tuple2 lambda = await cognito.lambda(POST, body);
  //   Uri url = lambda.item1;
  //   Map<String, String>? headers = lambda.item2;
  //   http.Response res = await _httpPost(url, headers, body);
  //   String decodedBody =
  //       const Utf8Decoder(allowMalformed: true).convert(res.bodyBytes);
  //   return decodedBody;
  // }
}
