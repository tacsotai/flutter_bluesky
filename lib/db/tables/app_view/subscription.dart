import 'package:isar/isar.dart';
part 'subscription.g.dart';

@collection
class Subscription {
  // isar ruled ID
  Id id = Isar.autoIncrement;

  // pds provider
  @Index(type: IndexType.value)
  late String provider;

  // user id
  @Index(type: IndexType.value)
  late String did;

  String service;
  String method;
  String state;

  Subscription({
    required this.service,
    required this.method,
    required this.state,
  });
}
