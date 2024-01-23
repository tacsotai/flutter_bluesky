import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/login.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:flutter_bluesky/screen/parts/adjuser.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';

class Provider extends StatefulWidget {
  static Screen screen = Screen(Provider, const Icon(Icons.list));
  const Provider({Key? key}) : super(key: key);

  @override
  ProviderScreen createState() => ProviderScreen();
}

class ProviderScreen extends State<Provider> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller.text = defaultProvider;
  }

  final _controller = TextEditingController();
  String message = "Not connected to any provider yet.";

  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Flutter Bluesky example App'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: listsBody([
        Card(child: Padding(padding: const EdgeInsets.all(10), child: form())),
        Center(child: Text(message)),
      ]),
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(labelText: tr(Provider.screen.name)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                // It is domain like: bsky.social
                String key = _controller.text.split(".")[0];
                setPlugin(FlutterBluesky(_controller.text, key));
                Tuple2 res = await plugin.connect();
                setState(() {
                  _process(res);
                });
              },
              child: Text(tr('connect')),
            ),
          ),
        ],
      ),
    );
  }

  void set(Tuple2 res) async {
    message = json.encode(res.item2);
  }

  void _process(Tuple2 res) {
    if (res.item1 != 200) {
      message = res.item2["message"];
    } else {
      debugPrint("serverDescription: ${plugin.serverDescription}");
      Navigator.pushNamed(context, LoginScreen.route);
    }
  }
}
