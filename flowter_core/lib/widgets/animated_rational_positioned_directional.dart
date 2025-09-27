import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RationalAnimatedPositioned extends StatefulWidget {
  final double topRatio;
  final double startRatio;
  final double endRatio;
  final double bottomRatio;
  final double widthRatio;
  final double heightRatio;
  final Widget child;

  const RationalAnimatedPositioned({
    super.key,
    this.topRatio = 0,
    this.startRatio = 0,
    this.endRatio = 0,
    this.bottomRatio = 0,
    this.widthRatio = 0,
    this.heightRatio = 0,
    required this.child,
    required this.duration,
    required this.curve,
  });

  final Duration duration;
  final Curve curve;

  @override
  createState() => _RationalAnimatedPositionedState();
}

class _RationalAnimatedPositionedState extends State<RationalAnimatedPositioned> {


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentSize = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          children: [
            AnimatedPositionedDirectional(
                  top: widget.topRatio * parentSize.height,
                  start: widget.startRatio * parentSize.width,
                  end: widget.endRatio * parentSize.width,
                  bottom: widget.bottomRatio * parentSize.height,
                  width: widget.widthRatio * parentSize.width,
                  height: widget.heightRatio * parentSize.height,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: widget.child,
            ),
          ],
        );
      },
    );
  }
}