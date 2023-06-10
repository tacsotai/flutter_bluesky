// see lexicons.app.bsky.graph.getFolows
import 'package:flutter_bluesky/api/model/actor.dart';

class FollowResponse {
  ProfileViewBasic subject;
  List follows = []; // List<ProfileViewBasic>
  String? cursor;

  FollowResponse(Map body)
      : subject = ProfileViewBasic(body["subject"]),
        follows = body["follows"],
        cursor = body["cursor"];
}
