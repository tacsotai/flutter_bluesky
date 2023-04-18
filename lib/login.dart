import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_login/flutter_login.dart';
// ignore: implementation_imports
import 'package:flutter_login/src/regex.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_bluesky/screen.dart';

const Duration loginTime = Duration(milliseconds: 2250);

class LoginScreen extends StatelessWidget {
  static const route = '/auth';
  const LoginScreen({Key? key}) : super(key: key);

  // result is null or error message with multi language.
  response(Tuple2 result) {
    return Future.delayed(loginTime).then((_) {
      if (result.item1 == 200) {
        return null;
      }
      // error message
      return result.item2["message"]; // TODO multi lang.
    });
  }

  Future<String?> signUp(SignupData data) async {
    return response(await plugin.register("email", "handle", "password"));
  }

  Future<String?> login(LoginData data) async {
    return response(await plugin.login("emailOrHandle", "password"));
  }

  Future<String?> recoverPassword(String name) async {
    // TOOD
    return response(await plugin.login("emailOrHandle", "password"));
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: tr('title'),
      loginAfterSignUp: false,
      onLogin: login,
      onSignup: signUp,
      onRecoverPassword: recoverPassword,
      onSubmitAnimationCompleted: () {
        _view(context);
      },
      theme: _theme(context),
      messages: _messages(),
      termsOfService: _terms(),
      userValidator: _userValidator,
      passwordValidator: _passwordValidator,
    );
  }

  static LoginTheme _theme(BuildContext context) {
    return LoginTheme(
        primaryColor: Theme.of(context).colorScheme.primary,
        accentColor: Theme.of(context).colorScheme.secondary);
  }

  static String? _userValidator(value) {
    if (value!.isEmpty || !Regex.email.hasMatch(value)) {
      return tr('invalid.email');
    }
    return null;
  }

  static String? _passwordValidator(value) {
    if (value!.isEmpty || value.length <= 2) {
      return tr('password.too.short');
    }
    return null;
  }

  static LoginMessages _messages() {
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
      signUpSuccess: tr('SignUp.success'),
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

  static void _view(BuildContext context) {
    // below code store login state at restart.
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => homeScreen(context),
    ));
  }

  static List<TermOfService> _terms() {
    return [
      TermOfService(
        id: 'general-term',
        mandatory: true,
        text: tr('term.of.services'),
        linkUrl: tr('term.linkUrl'),
        initialValue: true,
        validationErrorMessage: 'Required',
      )
    ];
  }
}
