class Repost {
  // pds provider
  late String provider;

  // user id
  late String did;

  String uri;
  String cid;
  String creator;
  String subject;
  String subjectCid;
  String createdAt;
  String indexedAt;

  Repost({
    required this.uri,
    required this.cid,
    required this.creator,
    required this.subject,
    required this.subjectCid,
    required this.createdAt,
    required this.indexedAt,
  });
}
