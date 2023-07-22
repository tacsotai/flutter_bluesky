import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/db/accessor.dart';

const defaultProvider = "https://bsky.social";
const xrpc = "xrpc";
const session = 'Session'; // hive table name

class Session {
  ProfileViewDetailed? actor;
  String? did;
  String? handle;
  String? email;
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

  static Map get model {
    return getModel(session);
  }

  Map get get {
    return accessor.get(session, provider);
  }

  void set(Map item) {
    setTokens(item["did"], item["handle"], item["email"], item["accessJwt"],
        item["refreshJwt"]);
    accessor.put(session, provider, item);
  }

  void setTokens(String did, String handle, String email, String accessJwt,
      String refreshJwt) {
    this.did = did;
    this.handle = handle;
    this.email = email;
    this.accessJwt = accessJwt;
    this.refreshJwt = refreshJwt;
  }

  void setActor(ProfileViewDetailed actor) {
    this.actor = actor;
  }

  void remove() {
    accessor.remove(session, provider);
  }
}
