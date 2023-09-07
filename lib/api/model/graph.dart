// see lexicons app.bsky.graph.getFollows
import 'package:flutter_bluesky/api/model/actor.dart';

class FollowsResponse {
  ProfileView subject;
  List follows = []; // List<ProfileView>
  String? cursor;

  FollowsResponse(Map body)
      : subject = ProfileView(body["subject"]),
        follows = body["follows"],
        cursor = body["cursor"];
}
