import 'package:flutter/material.dart';

class LayoutPositionedDirectional extends StatelessWidget {
  final Widget child;
  final double Function(double widthLayout)? start;
  final double Function(double widthLayout)? end;
  final double Function(double heightLayout)? top;
  final double Function(double heightLayout)? bottom;
  final double Function(double widthLayout)? width;
  final double Function(double heightLayout)? height;

  const LayoutPositionedDirectional({
    super.key,
    required this.child,
    this.start,
    this.end,
    this.top,
    this.bottom,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double widthLayout = constraints.maxWidth;
        final double heightLayout = constraints.maxHeight;

        final double? startValue = start?.call(widthLayout);
        final double? endValue = end?.call(widthLayout);
        final double? topValue = top?.call(heightLayout);
        final double? bottomValue = bottom?.call(heightLayout);
        final double? widthValue = width?.call(widthLayout);
        final double? heightValue = height?.call(heightLayout);

        return Stack(
          children: [
            PositionedDirectional(
              start: startValue,
              end: endValue,
              top: topValue,
              bottom: bottomValue,
              width: widthValue,
              height: heightValue,
              child: child,
            ),
          ],
        );
      },
    );
  }
}
