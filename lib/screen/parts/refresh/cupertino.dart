// https://github.com/jamesblasco/github_demo/blob/80773d2ebf105d58f97b4499472cc523c157203f/lib/src/widgets/refresh_control.dart
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

typedef RefreshCallback = Future<void> Function();

class SliverRefreshControl extends StatelessWidget {
  final RefreshCallback? onRefresh;

  const SliverRefreshControl({Key? key, this.onRefresh}) : super(key: key);

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
