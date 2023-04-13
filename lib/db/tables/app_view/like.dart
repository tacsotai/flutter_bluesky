import 'package:isar/isar.dart';
part 'like.g.dart';

@collection
class Like {
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
  String subject;
  String subjectCid;
  String createdAt;
  String indexedAt;

  Like({
    required this.uri,
    required this.cid,
    required this.creator,
    required this.subject,
    required this.subjectCid,
    required this.createdAt,
    required this.indexedAt,
  });
}
