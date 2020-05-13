import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lzstring/lzstring.dart';

class DB {
   static final _instance = DB._ctor();

   bool initialised = false;

   DB._ctor();

  factory DB() {
    return _instance;
  }

  List<Future> _ops = List();

  /*Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }*/


  init() async {
    await Hive.initFlutter();
/*
    if (!kIsWeb) {
      final path = await _localPath;
      await Hive.initFlutter(path);
    } else
      {
        Hive.initFlutter();
      }
*/

    _prefs = await Hive.openBox('prefss');

  }

  Box _prefs;


  getPref(key, {String defaultValue:''}) {
    final String cv= _prefs.get(key, defaultValue:defaultValue);
    return cv.isNotEmpty ? _dcmp(cv) : '';
  }

  setPref(String key, String value) {
    _prefs.put(key,value.isNotEmpty ? _cmp(value) : '');
  }

  Future<Box> get _openBigBox async {
    print('Hive.openBox');
    final op = Hive.openBox('data1');
    print('Hive.openedBox');

    _ops.add(op);
    return op;
  }

  Box _big;

  Future beginBig() async {
    print('openBigBox');
    _big = await _openBigBox;
  }

  Future endBig() async {
    await Future.wait<Object>(_ops);
    _ops.clear();
    await _big.compact();
    await _big.close();
  }

  String getBig(String key) {
    print('getBig');
    final big =  _big.get(key);
    print('gotBig');
    return big;
  }

  Future setBig(String key,  dynamic value) async {
    final op = _big.put(key, value);
    _ops.add(op);
    return  op;
  }

}


String _cmp(String s) {
  return LZString.compress(s);
}

String _dcmp(String s) {
  return LZString.decompress(s);
}




