import 'package:flutter/material.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/connecting.dart';
import 'package:flutter_bluesky/screen/parts/timelines.dart';
import 'package:tuple/tuple.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static Screen screen = Screen(Home, const Icon(Icons.home_outlined));

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with Base {
  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: Text(Home.screen.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: body(context),
        floatingActionButton: post(context),
        bottomNavigationBar: menu(context));
  }

  // https://zenn.dev/sqer/articles/db20a4d735fb7e5928ba
  Widget body(BuildContext context) {
    return FutureBuilder(
      future: plugin.timeline(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _body(snapshot);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _body(snapshot) {
    if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    }
    if (!snapshot.hasData) {
      return const Text("Not found the data.");
    } else {
      Tuple2? res = snapshot.data;
      if (res!.item1 != 200) {
        return listsBody(Connecting(context).listview());
      } else {
        return scrollbar(context, res.item2); // normal case
      }
    }
  }
  }
}
