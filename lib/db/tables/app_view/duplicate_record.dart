class DuplicateRecord {
  // pds provider
  late String provider;

  // user id
  late String did;

  String uri;
  String cid;
  String duplicateOf;
  String indexedAt;

  DuplicateRecord({
    required this.uri,
    required this.cid,
    required this.duplicateOf,
    required this.indexedAt,
  });
}
