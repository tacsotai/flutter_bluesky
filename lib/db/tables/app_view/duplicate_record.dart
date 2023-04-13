import 'package:isar/isar.dart';
part 'duplicate_record.g.dart';

@collection
class DuplicateRecord {
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
  String duplicateOf;
  String indexedAt;

  DuplicateRecord({
    required this.uri,
    required this.cid,
    required this.duplicateOf,
    required this.indexedAt,
  });
}
