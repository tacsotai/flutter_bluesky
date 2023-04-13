import 'package:isar/isar.dart';
part 'account.g.dart';

@collection
class Account {
  // isar ruled ID
  Id id = Isar.autoIncrement;

  // pds provider
  @Index(type: IndexType.value)
  late String provider;

  // user id
  @Index(type: IndexType.value)
  late String did;

  @Index(type: IndexType.value)
  late String handle;

  late String password;

  late String accessJwt;

  late String refreshJwt;
}
