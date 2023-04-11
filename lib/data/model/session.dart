class Session {
  String handle;
  String did;
  String? email;
  String? accessJwt;
  String? refreshJwt;

  Session({
    required this.handle,
    required this.did,
    this.email,
    this.accessJwt,
    this.refreshJwt,
  });
}
