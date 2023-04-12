class Profile {
  String uri;
  String cid;
  String creator;
  String? displayName;
  String? description;
  String? avatarCid;
  String? bannerCid;
  String indexedAt;

  Profile({
    required this.uri,
    required this.cid,
    required this.creator,
    this.displayName,
    this.description,
    this.avatarCid,
    this.bannerCid,
    required this.indexedAt,
  });
}
