import 'package:isar/isar.dart';
part 'post_embed.g.dart';

@collection
class PostEmbedImage {
  // isar ruled ID
  Id id = Isar.autoIncrement;

  // pds provider
  @Index(type: IndexType.value)
  late String provider;

  // user id
  @Index(type: IndexType.value)
  late String did;

  String postUri;
  int position;
  String imageCid;
  String alt;

  PostEmbedImage({
    required this.postUri,
    required this.position,
    required this.imageCid,
    required this.alt,
  });
}

@collection
class PostEmbedExternal {
  // isar ruled ID
  Id id = Isar.autoIncrement;

  // pds provider
  @Index(type: IndexType.value)
  late String provider;

  // user id
  @Index(type: IndexType.value)
  late String did;

  String postUri;
  String uri;
  String title;
  String description;
  String? thumbCid;

  PostEmbedExternal({
    required this.postUri,
    required this.uri,
    required this.title,
    required this.description,
    this.thumbCid,
  });
}

@collection
class PostEmbedRecord {
  // isar ruled ID
  Id id = Isar.autoIncrement;

  // pds provider
  @Index(type: IndexType.value)
  late String provider;

  // user id
  @Index(type: IndexType.value)
  late String did;

  String postUri;
  String embedUri;
  String embedCid;

  PostEmbedRecord({
    required this.postUri,
    required this.embedUri,
    required this.embedCid,
  });
}
