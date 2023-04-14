class Follow {
  // pds provider
  late String provider;

  // user id
  late String did;

  String uri;
  String cid;
  String creator;
  String subjectDid;
  String createdAt;
  String indexedAt;

  Follow({
    required this.uri,
    required this.cid,
    required this.creator,
    required this.subjectDid,
    required this.createdAt,
    required this.indexedAt,
  });
}
