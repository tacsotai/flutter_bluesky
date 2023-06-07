import 'package:flutter_bluesky/api/model/actor.dart';

class ListNotifications {
  String? cursor;
  List notifications = [];

  ListNotifications(Map body)
      : cursor = body["cursor"],
        notifications = body["notifications"];
}

class Notification {
  final String uri;
  final String cid;
  final ProfileView author;
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
        author = ProfileView(map["author"]),
        reason = map["reason"],
        reasonSubject = map["reasonSubject"],
        record = map["record"],
        isRead = map["isRead"],
        indexedAt = DateTime.parse((map["indexedAt"])),
        labels = map["labels"];
}
