import 'dart:io';
import 'package:http/http.dart';

// This Exception is only for that syncronization is fail or not.
class SyncException implements Exception {
  final Exception original;
  SyncException(this.original);
}

class APIGetException implements HttpException {
  final Uri url;
  final Map<String, String>? headers;
  final Response res;

  const APIGetException(this.url, this.headers, this.res);

  @override
  String get message {
    return "url:$url, headers:$headers, Status:${res.statusCode}, Body:${res.body}";
  }

  @override
  Uri? get uri => url;
}

class APIPostException implements HttpException {
  final Uri url;
  final Map<String, String>? headers;
  final Map<String, dynamic> body;
  final Response res;

  const APIPostException(this.url, this.headers, this.body, this.res);

  @override
  String get message {
    return "url:$url, headers:$headers, body:$body, Status:${res.statusCode}, Body:${res.body}";
  }

  @override
  Uri? get uri => url;
}
