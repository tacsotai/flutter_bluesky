import 'package:flutter_bluesky/data/model/actor.dart';

class Notification {
  final String uri;
  final String cid;
  final Actor author;
  final String reason;
  final String reasonSubject;
  final Map record;
  final bool isRead;
  final DateTime indexedAt;

  Notification({
    required this.uri,
    required this.cid,
    required this.author,
    required this.reason,
    required this.reasonSubject,
    required this.record,
    required this.isRead,
    required this.indexedAt,
  });
}
