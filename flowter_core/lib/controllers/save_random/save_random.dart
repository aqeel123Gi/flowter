// Class to save random uuid if not exists in hive by key

import 'package:hive/hive.dart';

import '../../functions/key_generator.dart';


class SaveRandom {
  static const String boxName = "SaveRandom";
  static late Box box;

  static Future<String> get(String key) async {
    box = await Hive.openBox(boxName);
    if(!box.containsKey(key)){
      String random = Generator.getKey(length: 20);
      box.put(key, random);
      return random;
    }else{
      return box.get(key)!;
    }
  }

}