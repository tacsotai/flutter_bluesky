import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/db/accessor.dart';

const defaultProvider = "https://bsky.social";
const defaultKey = "bsky";
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
  String key;

  Session({
    required this.provider,
    required this.key,
  });

  static Session create({String? provider, String? key}) {
    return Session(
      provider: provider ?? defaultProvider,
      key: key ?? defaultKey,
    );
  }

  static Map get model {
    return getModel(session);
  }

  Map get get {
    return accessor.get(session, key);
  }

  void set(Map item) {
    setTokens(
      item["did"],
      item["handle"],
      item["email"],
      item["accessJwt"],
      item["refreshJwt"],
    );
    accessor.put(session, key, item);
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
    accessor.remove(session, key);
  }
}
