import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/db/accessor.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/home.dart';
import 'package:flutter_bluesky/screen/me.dart';
import 'package:flutter_bluesky/screen/notfifications.dart';
import 'package:flutter_bluesky/screen/parts/button/button_manager.dart';
import 'package:flutter_bluesky/screen/parts/timeline.dart';
import 'package:flutter_bluesky/screen/parts/menu.dart';
import 'package:flutter_bluesky/screen/post.dart';
import 'package:flutter_bluesky/screen/settings.dart';
import 'package:flutter_bluesky/screen/profile/edit_profile.dart';
import 'package:flutter_bluesky/screen/provider.dart';
import 'package:flutter_bluesky/screen/base.dart';
import 'package:flutter_bluesky/screen/search.dart';
import 'package:flutter_bluesky/screen/profile.dart';
import 'package:flutter_bluesky/screen/thread.dart';
import 'package:flutter_bluesky/transition_route_observer.dart';
import 'package:flutter_bluesky_example/sample_timeline.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
        colorSchemeSeed: Colors.indigoAccent,
        brightness: Brightness.light,
      ),
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
  // TODO add other languages.
  timeago.setLocaleMessages('ja', timeago.JaMessages());

  await initHive();
  await restoreSession();
  initMenu();
  initScreen();
}

Future<void> initHive() async {
  await Hive.initFlutter();
  await openBox();
}

Future<void> restoreSession() async {
  Map item = {};
  if (isAlive) {
    item = plugin.api.session.get;
  } else {
    for (MapEntry entry in Session.model.entries) {
      setPlugin(FlutterBluesky(provider: entry.key));
      await plugin.connect();
      item = entry.value;
      break;
    }
  }
  if (item.isNotEmpty) {
    plugin.api.session.set(item);
    plugin.refresh();
  }
}

void initScreen() {
  PluggableWidget me = Me();
  pluggables.add(Home());
  pluggables.add(Search());
  pluggables.add(Notifications());
  pluggables.add(me);
  meIndex = pluggables.indexOf(me);
  customPostTL = SamplePostTimeline();
  buttonManager = DefaultButtonManager();
}

void initMenu() {
  menus.add(Menu(
      prop: "Settings",
      icon: Settings.screen.icon.icon!,
      transfer: const Settings()));
}

Future<void> initApp(String name, StatelessWidget appWidget) async {
  await EasyLocalization.ensureInitialized();
  await init();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ja', 'JP')],
        path: 'assets/langs', // <-- change the path of the translation files
        fallbackLocale: const Locale('ja', 'JP'),
        child: appWidget),
  );
}
