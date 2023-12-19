import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

// https://github.com/tacsotai/atproto/blob/local/packages/identifier/src/handle.ts
const emailTaken = "Email already taken: ";
const handleTaken = "Handle already taken: ";
const handleTooLong = "Handle too long";
const handleTooShort = "Handle too short";
// other; same message for this project.
// const handleInvalid = "Invalid characters in handle";
// const handleDotContain = "Input/handle must be a valid handle";

// It can change behaviors.
LoginUtil? loginUtil;

class LoginUtil {
  static LoginUtil get instance {
    return loginUtil ?? LoginUtil();
  }

  String rename(String message) {
    if (message.startsWith(emailTaken)) {
      return emailMsg(message.substring(emailTaken.length));
    } else if (message.startsWith(handleTaken)) {
      return handleMsg(message.substring(handleTaken.length));
    } else if (message.contains(handleTooLong)) {
      return longMsg;
    } else if (message.contains(handleTooShort)) {
      return shortMsg;
    } else {
      return inavalidMsg;
    }
  }

  String emailMsg(String email) {
    return tr("signup.email.taken", args: [email]);
  }

  String handleMsg(String handle) {
    handle = withoutDomain(handle);
    return tr("signup.handle.taken", args: [handle]);
  }

  String get longMsg {
    return tr("signup.handle.long");
  }

  String get shortMsg {
    return tr("signup.handle.short");
  }

  String get inavalidMsg {
    return tr("signup.handle.invalid");
  }
}
