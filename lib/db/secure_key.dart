import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

// https://docs.hivedb.dev/#/advanced/encrypted_box?id=encrypted-box
const storageKey = 'Random'; // Never change the value.
const secureStorage = FlutterSecureStorage();

Future<List<int>> secureKey() async {
  final encryprionKey = await secureStorage.read(key: storageKey);
  if (encryprionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(key: storageKey, value: base64UrlEncode(key));
  }
  final key = await secureStorage.read(key: storageKey);
  final encryptionKey = base64Url.decode(key!);
  return encryptionKey;
}
