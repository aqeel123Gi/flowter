import 'package:flutter/material.dart';
import 'package:flowter/flowter.dart';

class ButtonData<T> {
  ButtonData({
    this.id,
    this.color,
    this.iconData,
    this.icon,
    this.title,
    this.titleBuilder,
    this.onPressed,
    this.onLongPress,
    this.key,
    this.data,
    this.focused,
    this.popOnPressed,
  });

  T? id;
  GlobalKey? key;
  Color? color;
  String? title;
  String Function()? titleBuilder;
  IconData? iconData;
  SDIcon? icon;
  bool? focused;
  bool? popOnPressed;
  dynamic data;
  void Function()? onPressed;
  void Function()? onLongPress;

  static int? getIndexOfFocused(List<ButtonData> buttons) {
    for (int i = 0; i < buttons.length; i++) {
      if (buttons[i].focused == true) {
        return i;
      }
    }
    return null;
  }
}

extension ButtonDataExtension<T> on List<ButtonData<T>> {
  void forTabsController(InteractiveTabsController controller) {
    for (int i = 0; i < length; i++) {
      this[i].onPressed = () {
        controller.toTab(i);
      };
    }
    controller.addListenerOnStartTabChanging((i) {
      setFocusedOne(i);
    });
  }

  void setFocusedOne(int index) {
    for (int i = 0; i < length; i++) {
      if (i == index) {
        this[i].focused = true;
      } else {
        this[i].focused = false;
      }
    }
  }
}
