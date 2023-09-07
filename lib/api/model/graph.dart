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

//see lexicons app.bsky.graph.getFollowers
class FollowersResponse {
  ProfileView subject;
  List followers = []; // List<ProfileView>
  String? cursor;

  FollowersResponse(Map body)
      : subject = ProfileView(body["subject"]),
        followers = body["followers"],
        cursor = body["cursor"];
}
