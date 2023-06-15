import 'package:flutter/material.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/home.dart';
import 'package:flutter_bluesky/screen/me.dart';
import 'package:flutter_bluesky/screen/notfifications.dart';
import 'package:flutter_bluesky/screen/parts/button/button_manager.dart';
import 'package:flutter_bluesky/screen/parts/timeline.dart';
import 'package:flutter_bluesky/screen/post.dart';
import 'package:flutter_bluesky/screen/profile/edit_profile.dart';
import 'package:flutter_bluesky/screen/provider.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/search.dart';
import 'package:flutter_bluesky/screen/profile.dart';
import 'package:flutter_bluesky/screen/thread.dart';
import 'package:flutter_bluesky/transition_route_observer.dart';
import 'package:flutter_bluesky_example/sample_timeline.dart';
// ignore: depend_on_referenced_packages
import 'package:timeago/timeago.dart' as timeago;
import 'package:easy_localization/easy_localization.dart';

const _appName = "flutter_blusky";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initApp(_appName, const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // https://zenn.dev/kafumi/scraps/d7aeed260985cc
      // title: tr('title'),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: ThemeColors.material,
          canvasColor: ThemeColors.secondary),
      navigatorObservers: [TransitionRouteObserver()],
      initialRoute: initialRoute,
      routes: {
        Provider.screen.route: (context) => const Provider(),
        LoginScreen.route: (context) => const LoginScreen(),
        Base.route: (context) => Base(),
        Post.screen.route: (context) => const Post(),
        Thread.screen.route: (context) => const Thread(),
        Profile.screen.route: (context) => const Profile(),
        EditProfile.screen.route: (context) => const EditProfile(),
      },
    );
  }
}

Future<void> init() async {
  PluggableWidget me = Me();
  pluggables.add(Home());
  pluggables.add(Search());
  pluggables.add(Notifications());
  pluggables.add(me);
  meIndex = pluggables.indexOf(me);
  customPostTL = SamplePostTimeline();
  buttonManager = DefaultButtonManager();

  // TODO add other languages.
  timeago.setLocaleMessages('ja', timeago.JaMessages());
}

Future<void> initApp(String name, StatelessWidget appWidget) async {
  await init();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ja', 'JP')],
        path: 'assets/langs', // <-- change the path of the translation files
        fallbackLocale: const Locale('ja', 'JP'),
        child: appWidget),
  );
}

class ThemeColors {
  static const MaterialColor material = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5), // login use it as background color.
      500: Color(_primaryValue),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
  static const int _primaryValue = 0xFF2196F3;
  static const Color primary = Color(_primaryValue);

  static Color secondary = Colors.white;
}
