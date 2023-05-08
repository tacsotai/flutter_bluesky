// see lexicons.app.bsky.actor.def

// ProfileViewBasic
class ProfileViewBasic {
  String did;
  String handle;
  String? displayName;
  String? avatar;
  Viewer viewer;
  List? labels;
  ProfileViewBasic(Map map)
      : did = map["did"],
        handle = map["handle"],
        displayName = map["displayName"],
        avatar = map["avatar"],
        viewer = Viewer(map["viewer"]),
        labels = map["labels"];
}

// profileView
class ProfileView extends ProfileViewBasic {
  String? description;
  DateTime? indexedAt;
  ProfileView(Map map)
      : description = map["description"],
        indexedAt = map["indexedAt"] == null
            ? null
            : DateTime.parse((map["indexedAt"])),
        super(map);
}

// profileViewDetailed
class ProfileViewDetailed extends ProfileView {
  String? banner;
  int followersCount;
  int followsCount;
  int postsCount;
  ProfileViewDetailed(Map map)
      : banner = map["banner"],
        followersCount = (map["followersCount"]),
        followsCount = (map["followsCount"]),
        postsCount = (map["postsCount"]),
        super(map);
}

// viewerState
class Viewer {
  bool? muted;
  String? following;
  String? followedBy;
  Viewer(Map map)
      : muted = map["muted"],
        following = map["following"],
        followedBy = map["followedBy"];
}
