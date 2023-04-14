class PostEmbedImage {
  // pds provider
  late String provider;

  // user id
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

class PostEmbedExternal {
  // pds provider
  late String provider;

  // user id
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

class PostEmbedRecord {
  // pds provider
  late String provider;

  // user id
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
