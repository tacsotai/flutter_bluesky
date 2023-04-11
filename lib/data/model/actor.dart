import 'package:flutter_bluesky/data/model.dart';
import 'package:flutter_bluesky/data/model/viewer.dart';

class Actor extends Model {
  final String did;
  final String handle;
  final Viewer viewer;

  Actor({
    required this.handle,
    required this.did,
    required this.viewer,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'did': did,
      'handle': handle,
      'viewer': viewer.toMap(),
    };
  }
}
