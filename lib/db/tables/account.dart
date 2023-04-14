class Account {
  // pds provider
  String provider;

  // user id
  String did;

  late String email;

  late String handle;

  late String password;

  late String accessJwt;

  late String refreshJwt;

  Account({
    required this.provider,
    required this.did,
  });
}
