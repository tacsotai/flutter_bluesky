class PostHierarchy {
  // pds provider
  late String provider;

  // user id
  late String did;

  String uri;
  String ancestorUri;
  int depth;

  PostHierarchy({
    required this.uri,
    required this.ancestorUri,
    required this.depth,
  });
}
