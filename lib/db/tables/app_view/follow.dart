import 'package:isar/isar.dart';
part 'follow.g.dart';

@collection
class Follow {
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
