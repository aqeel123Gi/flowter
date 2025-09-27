// import 'package:flutter/cupertino.dart';
//
// class StaticGlobalKey{
//   static final Map<String,GlobalKey> _keys = {};
//   static GlobalKey get(String keyName){
//     if(_keys.containsKey(keyName)){
//       return _keys[keyName]!;
//     }
//     GlobalKey newGlobalKey = GlobalKey();
//     _keys[keyName] = newGlobalKey;
//     return newGlobalKey;
//   }
// }