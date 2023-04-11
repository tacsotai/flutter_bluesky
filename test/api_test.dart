import 'package:flutter_bluesky/api.dart';
import 'package:flutter_bluesky/api/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

String testProvider = "http://localhost:2583";
Session session = Session.create(provider: testProvider);
void main() {
  API api = API(session: session);
  test('connect', () async {
    http.Response res = await api.get("com.atproto.server.describeServer");
    expect(res.statusCode, 200);
  });
}
