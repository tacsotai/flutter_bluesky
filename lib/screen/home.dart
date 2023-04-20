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
          // TODO consider below coding
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return const Text("Not found the data.");
          }
          return lists(context, res: snapshot.data);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  List<Widget> listview(BuildContext context, {Tuple2? res}) {
    if (res!.item1 != 200) {
      return Connecting(context).listview();
    } else {
      return Timelines(context, res.item2).listview();
    }
  }
}
