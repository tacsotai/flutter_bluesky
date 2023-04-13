import 'package:isar/isar.dart';
part 'profile.g.dart';

@collection
class Profile {
  // isar ruled ID
  Id id = Isar.autoIncrement;

  // pds provider
  @Index(type: IndexType.value)
  late String provider;

  // user id
  @Index(type: IndexType.value)
  late String did;

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
