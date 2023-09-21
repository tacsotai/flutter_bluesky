import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_bluesky/data/config.dart';

const String configJson = "assets/config.json";

class Assets {
  static Future<void> load() async {
    await Config.init(await loadAsset(configJson));
  }
}

Future<Map<String, dynamic>> loadAsset(String path) async {
  String data = await rootBundle.loadString(path);
  return json.decode(data);
}
