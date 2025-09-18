import 'package:flowter/classes/transform_data/transform_data.dart';
import 'package:flowter/functions/post_state.dart';
import 'package:flutter/material.dart';

class AnimatedTransform extends StatefulWidget {
  const AnimatedTransform({
    super.key,
    required this.data,
    required this.child,
  });

  final TransformData data;
  final Widget child;

  @override
  State<AnimatedTransform> createState() => _AnimatedTransformState();
}

class _AnimatedTransformState extends State<AnimatedTransform> {
  @override
  initState() {
    _currentTransformData = widget.data;
    super.initState();
  }

  late TransformData _currentTransformData;

  void _update() async {
    if (!_currentTransformData.appliedWith(widget.data)) {
      _currentTransformData = widget.data;
      Future.delayed(_currentTransformData.duration, () {
        addPostFrameCallback(() {
          if (mounted) {
            setState(() {
              _currentTransformData;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _update();

    return IgnorePointer(
      ignoring: _currentTransformData.ignorance,
      child: AnimatedOpacity(
          opacity: _currentTransformData.opacity,
          duration: _currentTransformData.duration,
          curve: _currentTransformData.curve,
          child: AnimatedContainer(
              height: _currentTransformData.height,
              width: _currentTransformData.width,
              transformAlignment: Alignment.center,
              transform: Matrix4.translationValues(
                  _currentTransformData.x +
                      (Directionality.of(context) == TextDirection.rtl
                          ? -_currentTransformData.forwardedX
                          : _currentTransformData.forwardedX),
                  _currentTransformData.y,
                  0)
                ..rotateZ(_currentTransformData.rotation)
                ..scale(
                    _currentTransformData.scale, _currentTransformData.scale),
              duration: _currentTransformData.duration,
              curve: _currentTransformData.curve,
              child: widget.child)),
    );
  }
}
