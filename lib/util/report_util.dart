import 'package:flutter/material.dart';
import 'package:flutter_bluesky/screen/parts/button.dart';

// https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/defs.json
enum ReasonType {
  reasonSpam,
  reasonViolation,
  reasonMisleading,
  reasonSexual,
  reasonRude,
  reasonOther
}

ReportButton reportButton(State state, Map<String, dynamic> subject,
    ReasonType reasonType, String? reason) {
  return ReportButton(
      state, subject, "com.atproto.moderation.defs#${reasonType.name}", reason);
}
