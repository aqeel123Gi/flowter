library data_place_holder;

import 'dart:math';

import 'package:flowter/enums/language_code.dart';
import 'package:flowter/extensions/extensions.dart';

part '_en_names.dart';
part '_ar_names.dart';

class DataPlaceHolder {
  static T id<T>() {
    return Random().nextInt(10000) as T;
  }

  static String name(LanguageCode languageCode) {
    switch (languageCode) {
      case LanguageCode.ar:
        return _arabicNames.getRandomElement;
      default:
        return _englishNames.getRandomElement;
    }
  }

  static String complexName(LanguageCode languageCode, int length) {
    return List.generate(length, (index) => name(languageCode)).join(" ");
  }
}
