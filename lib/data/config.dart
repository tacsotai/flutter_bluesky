late Config config;

class Config {
  final int timeout;
  final int sleep;

  static Future<void> init(Map<String, dynamic> map) async {
    config = Config(map);
  }

  Config(Map<String, dynamic> map)
      : timeout = map["timeout"],
        sleep = map["sleep"];
}
