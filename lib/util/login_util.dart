import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bluesky/screen/parts/timeline/common.dart';

const emailTaken = "Email already taken: ";
const handleTaken = "Handle already taken: ";

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
    }
    return message;
  }

  String emailMsg(String email) {
    return tr("signup.email.taken", args: [email]);
  }

  String handleMsg(String handle) {
    handle = withoutDomain(handle);
    return tr("signup.handle.taken", args: [handle]);
  }
}
