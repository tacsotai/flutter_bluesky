import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/feed.dart';

class CommonRecord {
  void append(List<Widget> widgets, Record record) {
    Widget text = Row(
      children: [
        Expanded(child: Text(record.text)),
      ],
    );
    widgets.add(text);
  }
}
