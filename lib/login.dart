import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/provider.dart';
import 'package:flutter_login/flutter_login.dart';
// ignore: implementation_imports
import 'package:flutter_login/src/regex.dart';
import 'package:tuple/tuple.dart';

String get initialRoute {
  if (isAlive) {
    if (hasSession) {
      return Base.route;
    } else {
      return LoginScreen.route;
    }
  } else {
    return Provider.screen.route;
  }
}

class LoginScreen extends StatelessWidget {
  static const route = '/auth';
  const LoginScreen({Key? key}) : super(key: key);

  String? response(Tuple2 res) {
    if (res.item1 == 200) {
      return null;
    } else {
      return res.item2["message"] as String;
    }
  }

  Future<String?> signUp(SignupData data) async {
    return response(
        await plugin.register(data.name!, getHandle(data), data.password!));
  }

  String getHandle(SignupData data) {
    String account = data.additionalSignupData!["handle"]!;
    String handle = account + plugin.domain;
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
      loginAfterSignUp: false,
      onLogin: login,
      onSignup: signUp,
      additionalSignupFields: _additionalSignupFields(),
      onRecoverPassword: recoverPassword,
      onConfirmRecover: confirmRecover,
      onSubmitAnimationCompleted: () {
        _view(context);
      },
      messages: _messages(),
      termsOfService: _terms(),
      userValidator: _userValidator,
      passwordValidator: _passwordValidator,
    );
  }

  List<UserFormField>? _additionalSignupFields() {
    return [UserFormField(keyName: "handle", displayName: tr('handle.hint'))];
  }

  String? _userValidator(value) {
    if (value!.isEmpty || !Regex.email.hasMatch(value)) {
      return tr('invalid.email');
    }
    return null;
  }

  String? _passwordValidator(value) {
    if (value!.isEmpty || value.length <= 2) {
      return tr('password.too.short');
    }
    return null;
  }

  LoginMessages _messages() {
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
      signUpSuccess: tr('signup.success'),
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

  void _view(BuildContext context) {
    // below code store login state at restart.
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Base(),
    ));
  }

  List<TermOfService> _terms() {
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
