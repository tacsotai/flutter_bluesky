import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';
import 'package:tuple/tuple.dart';

HeaderContent? customHeaderContent;

class Header extends StatelessWidget {
  final ProfileViewBasic author;
  final DateTime createdAt;
  final HeaderContent content = HeaderContent();
  Header({super.key, required this.author, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    if (customHeaderContent != null) {
      return customHeaderContent!.build(context, author, createdAt);
    }
    return content.build(context, author, createdAt);
  }
}

// Never define fileds.
class HeaderContent {
  Widget build(
      BuildContext context, ProfileViewBasic author, DateTime createdAt) {
    return padding(
        lr(
          left(author),
          right(context, createdAt),
          const Tuple2(5, 2),
        ),
        left: 0,
        top: 0,
        right: 0);
  }

  Widget left(ProfileViewBasic author) {
    return displayNameHandle(author);
  }

  Widget right(BuildContext context, DateTime createdAt) {
    return Text(datetime(context, createdAt),
        style: const TextStyle(fontSize: 12));
  }
}
