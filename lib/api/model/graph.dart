// see lexicons app.bsky.graph.getFollows
// https://github.com/tacsotai/flutter_bluesky/issues/141#issuecomment-1766001631
import 'package:flutter_bluesky/api/model/actor.dart';

List<ProfileView> actors(List list) {
  List<ProfileView> profileViews = [];
  for (Map map in list) {
    profileViews.add(ProfileView(map));
  }
  return profileViews;
}

class Graph {
  final List<ProfileView> actors;
  final String? cursor;

  Graph(this.actors, this.cursor);
}

class FollowsResponse {
  ProfileView subject;
  Graph graph;

  FollowsResponse(Map body)
      : subject = ProfileView(body["subject"]),
        graph = Graph(actors(body["follows"]), body["cursor"]);
}

//see lexicons app.bsky.graph.getFollowers
class FollowersResponse {
  ProfileView subject;
  Graph graph;
  FollowersResponse(Map body)
      : subject = ProfileView(body["subject"]),
        graph = Graph(actors(body["followers"]), body["cursor"]);
}

//see lexicons app.bsky.graph.getLists
//see lexicons app.bsky.graph.getListMutes
class ListsResponse {
  Graph graph;
  ListsResponse(Map body)
      : graph = Graph(actors(body["lists"]), body["cursor"]);
}

//see lexicons app.bsky.graph.getBlocks
class BlocksResponse {
  Graph graph;
  BlocksResponse(Map body)
      : graph = Graph(actors(body["blocks"]), body["cursor"]);
}

//see lexicons app.bsky.graph.getMutes
class MutesResponse {
  Graph graph;
  MutesResponse(Map body)
      : graph = Graph(actors(body["mutes"]), body["cursor"]);
}
