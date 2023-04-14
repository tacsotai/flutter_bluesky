import 'package:flutter/material.dart';
import 'dart:async';
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
  String message = "Connecting ..";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final plugin = FlutterBluesky();
    final String provider = plugin.getProvider();
    Tuple2 res = await plugin.connect();
    bool result = res.item1 == 200;

    if (!mounted) return;

    setState(() {
      String prefix = result ? "" : "Not ";
      message = '${prefix}Connected to $provider';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
