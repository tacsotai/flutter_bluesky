import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';
import 'package:flutter_bluesky/util/datetime_util.dart';

class Header extends StatelessWidget {
  final ProfileViewBasic author;
  final DateTime createdAt;
  const Header({super.key, required this.author, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 5, child: name()),
            Flexible(flex: 2, child: when(context)),
          ],
        ));
  }

  Widget when(BuildContext context) {
    return Text(datetime(context, createdAt),
        style: const TextStyle(fontSize: 12));
  }

  Widget name() {
    // debugPrint("context.size.width: ${context.size?.width}");
    return Wrap(children: [displayName(author, 18), sizeBox, handle(author)]);
  }
}
