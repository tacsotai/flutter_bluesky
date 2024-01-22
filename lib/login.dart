import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/data/const.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/util/base_util.dart';
import 'package:flutter_bluesky/util/login_util.dart';
import 'package:flutter_login/flutter_login.dart';
// ignore: implementation_imports
import 'package:flutter_login/src/regex.dart';
import 'package:tuple/tuple.dart';

class LoginScreen extends StatelessWidget {
  static const route = '/auth';
  static bool autoLogin = true;
  const LoginScreen({Key? key}) : super(key: key);

  String? response(Tuple2 res) {
    if (res.item1 == 200) {
      return null;
    } else {
      return LoginUtil.instance.rename(res.item2["message"]);
    }
  }

  Future<String?> signUp(SignupData data) async {
    Tuple2 res =
        await plugin.register(data.name!, getHandle(data), data.password!);
    if (autoLogin && res.item1 == 200) {
      return response(await plugin.login(data.name!, data.password!));
    }
    return response(res);
  }

  String getHandle(SignupData data) {
    String account = data.additionalSignupData!["handle"]!;
    String handle = account + plugin.userDomain;
    return handle;
  }

  Future<String?> login(LoginData data) async {
    return response(await plugin.login(data.name, data.password));
  }

  Future<String?> recoverPassword(String email) async {
    return response(await plugin.requestPasswordReset(email));
  }

  Future<String?> confirmRecover(String token, LoginData data) async {
    return response(await plugin.resetPassword(token, data.password));
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: tr('title'),
      loginAfterSignUp: autoLogin,
      onLogin: login,
      onSignup: signUp,
      additionalSignupFields: additionalSignupFields(),
      onRecoverPassword: recoverPassword,
      onConfirmRecover: confirmRecover,
      onSubmitAnimationCompleted: () {
        view(context);
      },
      messages: messages(),
      termsOfService: terms(),
      userValidator: userValidator,
      passwordValidator: passwordValidator,
    );
  }

  List<UserFormField>? additionalSignupFields() {
    return [
      UserFormField(
          keyName: "handle",
          displayName: tr('handle.hint'),
          fieldValidator: handleValidator)
    ];
  }

  String? userValidator(value) {
    if (value!.isEmpty || !Regex.email.hasMatch(value)) {
      return tr('invalid.email');
    }
    return null;
  }

  String? passwordValidator(value) {
    if (value!.isEmpty || value.length <= 2) {
      return tr('password.too.short');
    }
    return null;
  }

  String? handleValidator(value) {
    if (value!.isEmpty || !Const.handle.hasMatch(value)) {
      return tr('signup.handle.unmatch');
    }
    return null;
  }

  LoginMessages messages() {
    return LoginMessages(
      userHint: tr('user.hint'),
      passwordHint: tr('password.hint'),
      confirmPasswordHint: tr('confirm.password.hint'),
      forgotPasswordButton: tr('forgot.password'),
      loginButton: tr('login'),
      signupButton: tr('signup'),
      recoverPasswordButton: tr('recover.password'),
      recoverPasswordIntro: tr('recover.password.intro'),
      recoverPasswordDescription: tr('recover.password.description'),
      goBackButton: tr('go.back'),
      confirmPasswordError: tr('confirm.password.error'),
      recoverPasswordSuccess: tr('recover.password.success'),
      flushbarTitleError: tr('flushbar.title.error'),
      flushbarTitleSuccess: tr('flushbar.title.success'),
      signUpSuccess:
          autoLogin ? tr('login.after.signup') : tr('signup.success'),
      providersTitleFirst: tr('providers.title.first'),
      providersTitleSecond: tr('providers.title.second'),
      additionalSignUpSubmitButton: tr('additional.signup.submit'),
      additionalSignUpFormDescription: tr('additional.signup.form.description'),
      confirmSignupIntro: tr('confirm.signup.intro'),
      confirmationCodeHint: tr('confirmation.code.hint'),
      confirmationCodeValidationError: tr('confirmation.code.validation.error'),
      resendCodeButton: tr('resend.code'),
      resendCodeSuccess: tr('resend.code.success'),
      confirmSignupButton: tr('confirm.signup'),
      confirmSignupSuccess: tr('confirm.signup.success'),
      confirmRecoverIntro: tr('confirm.recover.intro'),
      recoveryCodeHint: tr('recovery.code.hint'),
      recoveryCodeValidationError: tr('recovery.code.validation.error'),
      setPasswordButton: tr('set.password'),
      confirmRecoverSuccess: tr('confirm.recover.success'),
      recoverCodePasswordDescription: tr('recover.code.password.description'),
    );
  }

  void view(BuildContext context) {
    // below code store login state at restart.
    pushBase(context);
  }

  List<TermOfService> terms() {
    return [
      TermOfService(
        id: 'general-term',
        mandatory: true,
        text: tr('term.of.services'),
        linkUrl: tr('term.linkUrl'),
        initialValue: true,
        validationErrorMessage: tr('required'),
      ),
      TermOfService(
        id: 'age-verification',
        mandatory: true,
        text: tr('age.verification'),
        initialValue: true,
        validationErrorMessage: tr('required'),
      )
    ];
  }
}
