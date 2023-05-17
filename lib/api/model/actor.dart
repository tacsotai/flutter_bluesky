// see lexicons.app.bsky.actor.def

// ProfileViewBasic
class ProfileViewBasic {
  String did;
  String handle;
  String? displayName;
  String? avatar;
  ProfileViewer viewer;
  List? labels;
  ProfileViewBasic(Map map)
      : did = map["did"],
        handle = map["handle"],
        displayName = map["displayName"],
        avatar = map["avatar"],
        viewer = ProfileViewer(map["viewer"]),
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

// app.bsky.actor.viewerState
class ProfileViewer {
  bool? muted;
  bool? blockedBy;
  String? blocking;
  String? following;
  String? followedBy;
  ProfileViewer(Map map)
      : muted = map["muted"],
        blockedBy = map["blockedBy"],
        blocking = map["blocking"],
        following = map["following"],
        followedBy = map["followedBy"];
}
