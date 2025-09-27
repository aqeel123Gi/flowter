import 'package:hive/hive.dart';

class Memory{

  static Future<void> save(String file, String key, dynamic data)async{
    Box box = await Hive.openBox(file);
    box.put(key, data);
  }

  static Future<void> remove(String file, String key)async{
    Box box = await Hive.openBox(file);
    box.delete(key);
  }

  static Future<dynamic> get(String file, String key, dynamic defaultValue)async{
    Box box = await Hive.openBox(file);
    return box.get(key, defaultValue: defaultValue);
  }


}