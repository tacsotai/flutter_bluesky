import 'package:flutter_bluesky/api/model/actor.dart';

const defaultProvider = "https://bsky.social";
const xrpc = "xrpc";

class Session {
  ProfileViewDetailed? actor;
  String? did;
  String? handle;
  String? accessJwt;
  String? refreshJwt;
  String provider;

  Session({
    required this.provider,
  });

  static Session create({String? provider}) {
    if (provider == null) {
      return Session(provider: defaultProvider);
    } else {
      return Session(provider: provider);
    }
  }

  void set(Map<String, dynamic> item) {
    setTokens(
        item["did"], item["handle"], item["accessJwt"], item["refreshJwt"]);
  }

  void setTokens(
      String did, String handle, String accessJwt, String refreshJwt) {
    this.did = did;
    this.handle = handle;
    this.accessJwt = accessJwt;
    this.refreshJwt = refreshJwt;
  }

  void setActor(ProfileViewDetailed actor) {
    this.actor = actor;
  }
}
