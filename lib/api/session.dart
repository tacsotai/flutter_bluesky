const defaultProvider = "https://bsky.social";
const xrpc = "xrpc";

class Session {
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
    setTokens(item["accessJwt"], item["refreshJwt"]);
  }

  void setTokens(String accessJwt, String refreshJwt) {
    this.accessJwt = accessJwt;
    this.refreshJwt = refreshJwt;
  }
}
