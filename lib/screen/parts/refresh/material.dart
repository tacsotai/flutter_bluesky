// This class is the copy of cupertino.dart
// But this class call refresh_copy.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/refresh/refresh_copy.dart';

typedef RefreshCallback = Future<void> Function();

class MaterialSliverRefreshControl extends StatelessWidget {
  final RefreshCallback? onRefresh;

  const MaterialSliverRefreshControl({Key? key, this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      builder: (
        BuildContext context,
        RefreshIndicatorMode refreshState,
        double pulledExtent,
        double refreshTriggerPullDistance,
        double refreshIndicatorExtent,
      ) {
        return CupertinoSliverRefreshControl.buildRefreshIndicator(
          context,
          refreshState,
          math.min(pulledExtent, refreshTriggerPullDistance),
          refreshTriggerPullDistance,
          refreshIndicatorExtent,
        );
      },
      onRefresh: onRefresh,
    );
  }
}
