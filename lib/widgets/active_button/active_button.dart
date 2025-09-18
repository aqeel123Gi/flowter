import 'package:flutter/material.dart';

import '../button/button.dart';


class ActivatedButton extends StatefulWidget {

  const ActivatedButton({
    super.key,
    required this.active,
    required this.height,
    required this.width,
    required this.onPressed,
    required this.decoration,
    required this.decorationOnFocused,
    required this.decorationOnActive,
    required this.foregroundColor,
    required this.duration,
    required this.curve,
    required this.builder,
  });

  final bool active;
  final double? height;
  final double? width;
  final BoxDecoration decoration;
  final BoxDecoration decorationOnFocused;
  final BoxDecoration decorationOnActive;
  final Color foregroundColor;
  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, bool active, bool focused) builder;
  final void Function() onPressed;

  @override
  State<ActivatedButton> createState() => _ActivatedButtonState();

}






class _ActivatedButtonState extends State<ActivatedButton> {
  @override
  Widget build(BuildContext context) {
    return Button(
      height: widget.height,
      width: widget.width,
      decoration: widget.active?widget.decorationOnActive:widget.decoration,
      decorationOnFocused: widget.active?widget.decorationOnActive:widget.decorationOnFocused,
      duration: widget.duration,
      curve: widget.curve,
      onPressed: widget.onPressed,
      contentBuilder: (BuildContext context, bool focused) => widget.active?widget.builder(context, true, focused):widget.builder(context, false, focused),
      foregroundColor: widget.foregroundColor,
    );
  }
}