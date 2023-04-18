import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_bluesky/screen.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';
import 'package:flutter_bluesky/screen/home.dart';

class Provider extends StatefulWidget {
  static Screen screen = Screen(Provider, const Icon(Icons.list));
  const Provider({Key? key}) : super(key: key);

  @override
  ProviderScreen createState() => ProviderScreen();
}

class ProviderScreen extends State<Provider> with Base {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller.text = defaultProvider;
  }

  final _controller = TextEditingController();
  String message = "No connected to any provider yet.";

  AppBar? appBar(BuildContext context) {
    return AppBar(
      title: const Text('Flutter Bluesky example App'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: lists(context),
    );
  }

  @override
  List<Widget> listview(BuildContext context) {
    return [
      form(),
      Center(child: Text(message)),
    ];
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
                setPlugin(FlutterBluesky(provider: _controller.text));
                Tuple2 res = await plugin.connect();
                // TOTO screen transfer
                setState(() {
                  push(context, Home.screen.route);
                  set(res);
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
}
