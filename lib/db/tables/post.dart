class Post {
  String uri;
  String cid;
  String creator;
  String text;
  String? replyRoot;
  String? replyRootCid;
  String? replyParent;
  String? replyParentCid;
  String createdAt;
  String indexedAt;

  Post({
    required this.uri,
    required this.cid,
    required this.creator,
    required this.text,
    this.replyRoot,
    this.replyRootCid,
    this.replyParent,
    this.replyParentCid,
    required this.createdAt,
    required this.indexedAt,
  });
}
