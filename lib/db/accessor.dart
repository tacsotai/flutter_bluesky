import 'package:flutter_bluesky/db/secure_key.dart';
import 'package:hive/hive.dart';

const dataBox = 'dataBox'; // Never change the value.
final Box _dataBox = Hive.box(dataBox);

Future<void> openBox() async {
  await Hive.openBox(dataBox,
      encryptionCipher: HiveAesCipher(await secureKey()));
}

Map getModel(String name) {
  Map model = {};
  if (_dataBox.containsKey(name)) {
    model = _dataBox.get(name);
  } else {
    _dataBox.put(name, model);
  }
  return model;
}

void setModel(String name, Map model) {
  _dataBox.put(name, model);
}

Accessor accessor = Accessor();

class Accessor {
  Map get(String name, String key) {
    Map model = getModel(name);
    if (model.isEmpty) {
      return {};
    } else {
      Map? value = model[key];
      return value ?? {};
    }
  }

  void put(String name, String key, Map value) {
    Map model = getModel(name);
    model[key] = value;
    setModel(name, model);
  }
}
