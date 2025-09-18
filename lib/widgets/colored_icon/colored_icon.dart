import 'package:flutter/material.dart';
import 'package:flowter/flowter.dart';

class ColoredIcon extends StatelessWidget {
  const ColoredIcon(
      {required this.iconSize,
      required this.color,
      super.key,
      this.expandingTappingSensitivity = 0,
      required this.containerSize,
      this.borderRadius,
      required this.icon,
      this.onPressed});

  final void Function()? onPressed;
  final double expandingTappingSensitivity;
  final double containerSize;
  final double? borderRadius;
  final double iconSize;
  final Color color;
  final SDIcon icon;

  @override
  Widget build(BuildContext context) {
    return Button(
      expandingTappingSensitivity: expandingTappingSensitivity,
      foregroundColor: color.withOpacityMultiply(0.1),
      onPressed: onPressed,
      height: containerSize,
      width: containerSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? containerSize),
        color: color.withOpacityMultiply(0.1),
      ),
      contentBuilder: (context, focused) =>
          Center(child: icon.withParams(color: color, size: iconSize)),
    );
  }
}
