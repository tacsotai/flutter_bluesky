import 'package:flutter_bluesky/data/model/viewer.dart';

class Actor {
  final String did;
  final String handle;
  final Viewer viewer;

  Actor({
    required this.handle,
    required this.did,
    required this.viewer,
  });
}
