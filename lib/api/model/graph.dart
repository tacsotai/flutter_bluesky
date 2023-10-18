// see lexicons app.bsky.graph.getFollows
// https://github.com/tacsotai/flutter_bluesky/issues/141#issuecomment-1766001631
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

//see lexicons app.bsky.graph.getLists
//see lexicons app.bsky.graph.getListMutes
class ListsResponse {
  List lists = []; // List<ProfileView>
  String? cursor;

  ListsResponse(Map body)
      : lists = body["lists"],
        cursor = body["cursor"];
}

//see lexicons app.bsky.graph.getBlocks
class BlocksResponse {
  List blocks = []; // List<ProfileView>
  String? cursor;

  BlocksResponse(Map body)
      : blocks = body["blocks"],
        cursor = body["cursor"];
}

//see lexicons app.bsky.graph.getMutes
class MutesResponse {
  List mutes = []; // List<ProfileView>
  String? cursor;

  MutesResponse(Map body)
      : mutes = body["mutes"],
        cursor = body["cursor"];
}
