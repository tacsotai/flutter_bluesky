import 'package:isar/isar.dart';
part 'post_hierarchy.g.dart';

@collection
class PostHierarchy {
  // isar ruled ID
  Id id = Isar.autoIncrement;

  // pds provider
  @Index(type: IndexType.value)
  late String provider;

  // user id
  @Index(type: IndexType.value)
  late String did;

  String uri;
  String ancestorUri;
  int depth;

  PostHierarchy({
    required this.uri,
    required this.ancestorUri,
    required this.depth,
  });
}
