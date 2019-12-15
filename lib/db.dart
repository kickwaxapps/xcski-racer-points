import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:lzstring/lzstring.dart';
import 'package:path_provider/path_provider.dart';

class DB {
   static final _instance = DB._ctor();

   bool initialised = false;

   DB._ctor();

  factory DB() {
    return _instance;
  }

  List<Future> _ops = List();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }


  init() async {
    if (!kIsWeb) {
      final path = await _localPath;
      Hive.init(path);
    }

    _prefs = await Hive.openBox('prefs');

  }

  Box _prefs;

  Future _F;

  getPref(key, {String defaultValue:''}) {
    final String cv= _prefs.get(key, defaultValue:defaultValue);
    return cv.isNotEmpty ? _dcmp(cv) : '';
  }

  setPref(String key, String value) {
    _prefs.put(key,value.isNotEmpty ? _cmp(value) : '');
  }

  Future<Box> get _openBigBox async {
    final op = Hive.openBox('data');
    _ops.add(op);
    return op;
  }

  Box _big;

  Future beginBig() async {
    _big = await _openBigBox;
  }

  Future endBig() async {
    await Future.wait<Object>(_ops);
    _ops.clear();
    await _big.compact();
    _big.close();
  }

  Future<String> getBig(String key) {
    final String value = _big.get(key, defaultValue: '');
    final op =  value.isNotEmpty ? compute(_dcmp, value) : Future.value('');
    _ops.add(op);
    return op;
  }

  Future setBig(String key, String value) async {
    final op0 = compute(_cmp, value);
    _ops.add(op0);
    final cmpValue = await op0;
    final op = _big.put(key, cmpValue);
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




