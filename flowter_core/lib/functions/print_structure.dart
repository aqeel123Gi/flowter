import 'package:flowter_core/extensions/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flowter_core/flowter_core.dart';

dynamic printStructure(dynamic data,
    {String base = "[ROOT]->", bool valuesTypes = false, String? title}) {
  if (!kDebugMode) {
    return data;
  }

  if (title != null) {
    if (kDebugMode) {
      print("/// $title ///");
    }
  }

  if (data is List) {
    if (data.isEmpty) {
      if (kDebugMode) {
        print("$base$data[EMPTY]");
      }
    }
    data.indexedMap((index, element) {
      if (kDebugMode) {
        printStructure(element, base: "$base[I:$index]->");
      }
    });
  } else if (data is Map) {
    data.forEach((key, value) {
      printStructure(value, base: "$base[K:$key]->");
    });
  } else {
    if (kDebugMode) {
      print("$base$data  :  ${data.runtimeType}");
    }
  }

  return data;
}
