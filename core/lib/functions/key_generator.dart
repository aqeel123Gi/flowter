import 'dart:math';

class Generator{
  static const String _digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  static String getKey({int length = 5,List<String>? exceptions}){
    while(true){
      String key = "";
      Random rand = Random();
      for (int i=0;i<length;i++) {
        key += _digits[rand.nextInt(_digits.length)];
      }
      if(!(exceptions!=null && exceptions.contains(key))) {
        return key;
      }
    }
  }
}