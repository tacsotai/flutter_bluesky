import 'package:hive/hive.dart';

const dataBox = 'dataBox'; // Never change the value.
final Box _dataBox = Hive.box(dataBox);

Future<void> openBox() async {
  await Hive.openBox(dataBox);
}

Map getFromDataBox(String key) {
  Map map = {};
  if (_dataBox.containsKey(key)) {
    map = _dataBox.get(key);
  } else {
    _dataBox.put(key, map);
  }
  return map;
}

// json to map, then save it.
void saveToDataBox(String key, Map map) {
  _dataBox.put(key, map);
}
