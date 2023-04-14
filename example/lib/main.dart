import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluesky/api/session.dart';

import 'package:tuple/tuple.dart';
import 'package:flutter_bluesky/flutter_bluesky.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // defalt provider = 'https://bsky.social'
    _controller.text = defaultProvider;
  }

  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  String message = "No connected to any provider yet.";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Bluesky example App'),
        ),
        body: Center(
          child: serverInfo(),
        ),
      ),
    );
  }

  Widget serverInfo() {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        form(),
        Center(child: Text(message)),
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(labelText: "Provider"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                final plugin = FlutterBluesky(provider: _controller.text);
                Tuple2 res = await plugin.connect();
                setState(() {
                  set(res);
                });
              },
              child: const Text('Connect'),
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
