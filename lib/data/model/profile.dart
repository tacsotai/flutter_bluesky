import 'package:flutter_bluesky/data/model/actor.dart';
import 'package:flutter_bluesky/data/model/viewer.dart';

class Profile extends Actor {
  final int followsCount;
  final int followersCount;
  final int postsCount;

  Profile({
    required super.handle,
    required super.did,
    required this.followsCount,
    required this.followersCount,
    required this.postsCount,
    required super.viewer,
  });
}
