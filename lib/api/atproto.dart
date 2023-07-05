import 'dart:typed_data';

import 'package:flutter_bluesky/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tuple/tuple.dart';

abstract class Atproto {
  final API api;
  Atproto({
    required this.api,
  });

  Future<Tuple2> describeServer(
      {bool? inviteCodeRequired,
      List<String>? availableUserDomains,
      Map<String, dynamic>? links}) async {
    http.Response res =
        await api.get("com.atproto.server.describeServer", params: {
      "inviteCodeRequired": inviteCodeRequired,
      "availableUserDomains": availableUserDomains,
      "links": links
    });
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // Account Register and auto Login
  Future<Tuple2> createAccount(String email, String handle, String password,
      {String? did, String? inviteCode, String? recoveryKey}) async {
    // TODO format check for handle.
    Map<String, dynamic> params = {
      "email": email,
      "handle": handle,
      "password": password
    };
    API.add(params, {
      "did": did,
      "inviteCode": inviteCode,
      "recoveryKey": recoveryKey,
    });
    http.Response res = await api.post("com.atproto.server.createAccount",
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // Login: id = email or handle
  Future<Tuple2> createSession(String identifier, String password) async {
    // TODO format check for handle.
    Map<String, dynamic> params = {
      "identifier": identifier,
      "password": password
    };
    http.Response res = await api.post("com.atproto.server.createSession",
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // TODO test
  Future<Tuple2> deleteSession() async {
    http.Response res = await api.post(
      "com.atproto.server.deleteSession",
      headers: {"Content-Type": "application/json"},
    );
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
    });
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> resetPassword(String token, String password) async {
    Map<String, dynamic> params = {"token": token, "password": password};
    http.Response res = await api.post("com.atproto.server.resetPassword",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${api.session.refreshJwt}"
        },
        body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  //com.atproto.server.requestPasswordReset
  Future<Tuple2> requestPasswordReset(String email) async {
    Map<String, dynamic> params = {"email": email};
    http.Response res =
        await api.post("com.atproto.server.requestPasswordReset",
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${api.session.refreshJwt}"
            },
            body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // requestAccountDelete
  Future<Tuple2> requestAccountDelete() async {
    http.Response res =
        await api.post("com.atproto.server.requestAccountDelete", headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${api.session.accessJwt}"
    });
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  //com.atproto.server.deleteAccount
  Future<Tuple2> deleteAccount(
      String did, String password, String token) async {
    Map<String, dynamic> params = {
      "did": did,
      "password": password,
      "token": token
    };
    http.Response res = await api.post("com.atproto.server.deleteAccount",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${api.session.accessJwt}"
        },
        body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  // see 'record' table on DB.
  Future<Tuple2> deleteRecord(String repo, String collection, String rkey,
      {String? swapRecord, String? swapCommit}) async {
    Map<String, dynamic> params = {
      "repo": repo,
      "collection": collection,
      "rkey": rkey,
    };
    API.add(params, {
      "swapRecord": swapRecord,
      "swapCommit": swapCommit,
    });
    http.Response res = await api.post("com.atproto.repo.deleteRecord",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${api.session.accessJwt}"
        },
        body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(res.statusCode, {});
  }

  Future<Tuple2> createRecord(
      String repo, String collection, Map<String, dynamic> record,
      {bool? validate, String? rkey, String? swapCommit}) async {
    Map<String, dynamic> params = {
      "repo": repo,
      "collection": collection,
      "record": record
    };
    API.add(params, {
      "validate": validate,
      "rkey": rkey,
      "swapCommit": swapCommit,
    });
    http.Response res = await api.post("com.atproto.repo.createRecord",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${api.session.accessJwt}"
        },
        body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> putRecord(
      String repo, String collection, String rkey, Map<String, dynamic> record,
      {bool? validate, String? swapRecord, String? swapCommit}) async {
    Map<String, dynamic> params = {
      "repo": repo,
      "collection": collection,
      "rkey": rkey,
      "record": record
    };
    API.add(params, {
      "validate": validate,
      "swapRecord": swapRecord,
      "swapCommit": swapCommit,
    });
    http.Response res = await api.post("com.atproto.repo.putRecord",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${api.session.accessJwt}"
        },
        body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> uploadBlob(Uint8List bytes, String contentType) async {
    http.Response res = await api.post("com.atproto.repo.uploadBlob",
        headers: {
          "Content-Type": contentType,
          "Authorization": "Bearer ${api.session.accessJwt}"
        },
        body: bytes);
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> listRecords(String collection, String repo,
      {int? limit, String? cursor, bool? reverse}) async {
    http.Response res =
        await api.get("com.atproto.server.listRecords", params: {
      "collection": collection,
      "repo": repo,
      "limit": limit,
      "cursor": cursor,
      "reverse": reverse
    }, headers: {
      "Authorization": "Bearer ${api.session.accessJwt}"
    });
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> resolveHandle(String handle) async {
    http.Response res = await api.get("com.atproto.identity.resolveHandle",
        params: {"handle": handle},
        headers: {"Authorization": "Bearer ${api.session.accessJwt}"});
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }

  Future<Tuple2> updateHandle(String handle) async {
    Map<String, dynamic> params = {
      "handle": handle,
    };
    http.Response res = await api.post("com.atproto.identity.updateHandle",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${api.session.accessJwt}"
        },
        body: json.encode(params));
    return Tuple2<int, Map<String, dynamic>>(
        res.statusCode, json.decode(res.body));
  }
}
