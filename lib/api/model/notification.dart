import 'package:flutter_bluesky/api/model/actor.dart';

class ListNotifications {
  String? cursor;
  List notificationList = [];

  ListNotifications(Map body)
      : cursor = body["cursor"],
        notificationList = body["notifications"];

  List<Notification> get notifications {
    List<Notification> list = [];
    for (var map in notificationList) {
      list.add(Notification(map));
    }
    return list;
  }
}

class Notification {
  final String uri;
  final String cid;
  final ProfileViewBasic author;
  final String reason;
  String? reasonSubject;
  // currently, no need to know detail.
  final Map record;
  final bool isRead;
  final DateTime indexedAt;
  List? labels;
  Notification(Map map)
      : uri = map["uri"],
        cid = map["cid"],
        author = ProfileViewBasic(map["author"]),
        reason = map["reason"],
        reasonSubject = map["reasonSubject"],
        record = map["record"],
        isRead = map["isRead"],
        indexedAt = DateTime.parse((map["indexedAt"])),
        labels = map["labels"];
}
