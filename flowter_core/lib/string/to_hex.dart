import 'dart:typed_data';

import 'package:flowter_core/flowter_core.dart';

String charToHex(String input) {
  List<int> charCodes = input.runes.toList();
  String hexString = charCodes.map((code) => code.toRadixString(16)).join('');
  return hexString;
}

String integerToHex(int number) {
  return number.toRadixString(16);
}

String convertUint8ListToText(Uint8List list) {
  String text = "";
  list.toList().forEach((i) => text = text + par(String.fromCharCode(i)));
  return par(text);
}

String convertUint8ListToHex(Uint8List list) {
  String text = "";
  list.toList().forEach((i) {
    String hex = integerToHex(i);
    if (hex.length == 1) {
      hex = "0$hex";
    }
    text = text + hex;
  });
  return text;
}
