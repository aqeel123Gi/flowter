import 'dart:ui';
import 'package:flowter_core/widgets/sd_icon/sd_icon.dart';

class EnumInfo<T extends Enum> {
  EnumInfo(
      {required this.key, this.color, this.text, this.icon, this.function});

  T key;
  Color? color;
  String Function()? text;
  SDIcon? icon;
  void Function()? function;
}

class EnumInfoGroup<T extends Enum> {
  EnumInfoGroup(List<EnumInfo<T>> enumInfoList) {
    for (EnumInfo<T> enumInfo in enumInfoList) {
      enumInfos[enumInfo.key] = enumInfo;
    }
  }

  Map<T, EnumInfo<T>> enumInfos = {};

  Color getColor(T key) {
    return enumInfos[key]!.color!;
  }

  String getText(T key) {
    return enumInfos[key]!.text!();
  }

  SDIcon getIcon(T key) {
    return enumInfos[key]!.icon!;
  }

  void Function() getFunction(T key) {
    return enumInfos[key]!.function!;
  }
}
