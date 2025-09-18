import 'package:framework/classes/window.dart';
import 'package:flutter/widgets.dart';

class KeyboardVisibility extends StatefulWidget {
  final Widget Function(BuildContext context, bool visibleKeyboard) builder;

  const KeyboardVisibility({super.key, required this.builder});

  @override
  createState() => _KeyboardVisibilityState();
}

class _KeyboardVisibilityState extends State<KeyboardVisibility>{


  @override
  Widget build(BuildContext context) {
    bool visibleKeyboard = Window.insetsBottom(context)>0;
    return widget.builder(context, visibleKeyboard);
  }
}