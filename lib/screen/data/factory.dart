import 'package:flutter_bluesky/screen/data/manager.dart';

ManagerFactory? managerFactory;

class ManagerFactory {
  ActorsDataManager getActorsDataManager(String name) {
    if (name == "followers") {
      return FollowersDataManager();
    } else {
      return FollowsDataManager();
    }
  }

  ProfileDataManager getProfileDataManager() {
    return ProfileDataManager();
  }
}
