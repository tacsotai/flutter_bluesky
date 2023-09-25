// This class define the detectors for Thread Screen.

import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/model/actor.dart';
import 'package:flutter_bluesky/screen/thread.dart';

class Detector {
  final BuildContext context;
  final Widget widget;

  Detector(this.context, this.widget);

  static Detector instance(BuildContext context, Widget widget) {
    return Detector(context, widget);
  }

  GestureDetector thread(ProfileViewBasic author, String uri) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Thread(
                    handle: author.handle,
                    uri: uri,
                  )),
        )
      },
      child: widget,
    );
  }
}
