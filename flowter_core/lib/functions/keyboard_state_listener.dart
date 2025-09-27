import 'package:flutter/services.dart';

class KeyboardShortcuts {

  static void onPhysicalKeyboardKeyIsNumberDigit(PhysicalKeyboardKey key, void Function(int) callback) {
    if (key == PhysicalKeyboardKey.digit0) {
      callback(0);
    } else if (key == PhysicalKeyboardKey.digit1) {
      callback(1);
    } else if (key == PhysicalKeyboardKey.digit2) {
      callback(2);
    } else if (key == PhysicalKeyboardKey.digit3) {
      callback(3);
    } else if (key == PhysicalKeyboardKey.digit4) {
      callback(4);
    } else if (key == PhysicalKeyboardKey.digit5) {
      callback(5);
    } else if (key == PhysicalKeyboardKey.digit6) {
      callback(6);
    } else if (key == PhysicalKeyboardKey.digit7) {
      callback(7);
    } else if (key == PhysicalKeyboardKey.digit8) {
      callback(8);
    } else if (key == PhysicalKeyboardKey.digit9) {
      callback(9);
    }
  }


}