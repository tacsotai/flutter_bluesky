class Subscription {
  // pds provider
  late String provider;

  // user id
  late String did;

  String service;
  String method;
  String state;

  Subscription({
    required this.service,
    required this.method,
    required this.state,
  });
}
