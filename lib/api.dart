import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/data/config.dart';

import 'package:http/http.dart' as http;

// discard API when use another provider.
class API {
  final Session session;
  API({
    required this.session,
  });

  Future<http.Response> get(String uri,
      {Map<String, String>? headers, Map<String, dynamic>? params}) async {
    Uri url = _uri(append(uri, params ?? {}));
    http.Response res = await http
        .get(url, headers: headers)
        .timeout(Duration(milliseconds: config.timeout));
    return res;
  }

  Future<http.Response> post(String uri,
      {required Map<String, String> headers, Object? body}) async {
    Uri url = _uri(uri);
    http.Response res = await http
        .post(url, headers: headers, body: body)
        .timeout(Duration(milliseconds: config.timeout));
    return res;
  }

  Uri _uri(String uri) {
    return Uri.parse("${session.provider}/$xrpc/$uri");
  }

  String append(String uri, Map<String, dynamic> params) {
    StringBuffer sb = StringBuffer("?");
    params.forEach((key, value) {
      if (value != null) {
        sb.write("$key=$value&");
      }
    });
    return "$uri${sb.toString().substring(0, sb.toString().length - 1)}";
  }

  static void add(Map<String, dynamic> params, Map<String, dynamic> option) {
    option.forEach((key, value) {
      if (value != null) {
        params[key] = value;
      }
    });
  }
}
