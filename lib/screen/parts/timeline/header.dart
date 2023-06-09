import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';
import 'package:tuple/tuple.dart';

class Header extends StatelessWidget {
  final ProfileViewBasic author;
  final DateTime createdAt;
  const Header({super.key, required this.author, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return padding(
      lr(displayNameHandle(author), when(context), const Tuple2(5, 2)),
      left: 0,
      top: 0,
      right: 0,
    );
  }

  Widget when(BuildContext context) {
    return Text(datetime(context, createdAt),
        style: const TextStyle(fontSize: 12));
  }
}
