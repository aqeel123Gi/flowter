import 'package:flutter/material.dart';
import 'package:flowter/flowter.dart';

class FadingGradientMask extends StatelessWidget {
  const FadingGradientMask({
    super.key,
    required this.child,
    required this.gradient,
  });

  final Widget child;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (rect) {
          return gradient
              .createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: child);
  }
}

class FadingGradientSide extends StatelessWidget {
  const FadingGradientSide(
      {required this.side,
      required this.length,
      required this.child,
      super.key});

  final Widget child;
  final Side side;
  final double length;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, c) => FadingGradientMask(
            gradient: {
              Side.top: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [Colors.transparent, Colors.black],
                  stops: [0, length / c.maxHeight]),
              Side.bottom: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: const [Colors.transparent, Colors.black],
                  stops: [0, length / c.maxHeight]),
            }[side]!,
            child: child));
  }
}
