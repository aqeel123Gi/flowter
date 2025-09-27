import 'dart:math';
import 'package:flowter_core/flowter_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/ui_key/ui_key.dart';

class CircularTapEffect extends StatefulWidget {
  @override
  createState() => _CircularTapEffectState();

  const CircularTapEffect(
      {super.key,
      this.uiKey,
      this.keyActions = const {},
      required this.child,
      this.onLongPressedWithinDuration,
      required this.color,
      this.ratioOfChildSize = 1.5,
      this.onPressed,
      this.fixed = false});

  final bool fixed;
  final GlobalKey<State<UiKey>>? uiKey;
  final Map<LogicalKeyboardKey, void Function()> keyActions;
  final Widget child;
  final MapEntry<Duration, void Function()>? onLongPressedWithinDuration;
  final Color color;
  final double ratioOfChildSize;
  final void Function()? onPressed;
}

class _CircularTapEffectState extends State<CircularTapEffect> {
  int pressNumber = 0;

  final GlobalKey<State<UiKey>> _uiKey = GlobalKey();

  double _distanceBetweenOffsets(Offset offset1, Offset offset2) {
    return sqrt(
        pow(offset2.dx - offset1.dx, 2) + pow(offset2.dy - offset1.dy, 2));
  }

  bool _up = true;
  Offset _clickedOn = const Offset(0, 0);
  Duration _duration = const Duration(seconds: 1);

  double _size = 0;

  double _maxScale() {
    return widget.ratioOfChildSize * _size;
  }

  late Color _color;
  double _scale = 0;
  double _opacity = 1.0;
  Curve _curve = Curves.linear;

  int _slowBySize() {
    return (widget.ratioOfChildSize * _size * 0.0065).floor() + 1;
  }

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (p) {
          _up = false;
          pressNumber++;
          if (widget.onLongPressedWithinDuration != null) {
            int tmp = pressNumber;
            Future.delayed(widget.onLongPressedWithinDuration!.key, () {
              if (!_up && tmp == pressNumber) {
                widget.onLongPressedWithinDuration!.value();
              }
            });
          }
          _clickedOn = p.position;
          setState(() {
            _duration = const Duration(seconds: 0);
            _color = widget.color;
            _scale = 1.0;
            _opacity = 1.0;
            _curve = Curves.easeOutCirc;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _duration = Duration(milliseconds: 500 * _slowBySize());
              _scale = _maxScale();
            });
          });
        },
        onPointerUp: (p) {
          _up = true;
          setState(() {
            _duration = Duration(milliseconds: 500 * _slowBySize());
            _scale = _maxScale();
          });
          Future.delayed(const Duration(milliseconds: 200), () {
            if (_up) {
              if (mounted) {
                setState(() {
                  _duration = const Duration(milliseconds: 500);
                  _opacity = 0.0;
                });
              }
            }
          });
          if (_distanceBetweenOffsets(_clickedOn, p.position) < 10 &&
              widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        onPointerCancel: (p) {
          _up = true;
          setState(() {
            _scale = _maxScale();
            _duration = const Duration(milliseconds: 100);
            _opacity = 0.0;
          });
        },
        onPointerMove: (p) {
          if (_distanceBetweenOffsets(_clickedOn, p.position) > 10) {
            _up = true;
          }
          setState(() {
            _scale = _maxScale();
            _duration = const Duration(milliseconds: 100);
            _opacity = 0.0;
          });
        },
        child: Stack(children: [
          Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Center(
                  child: AnimatedOpacity(
                      duration: _duration * 3,
                      opacity: _opacity,
                      curve: _curve,
                      child: AnimatedContainer(
                        height: 1,
                        width: 1,
                        curve: _curve,
                        duration: _duration,
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(1)),
                        transform: Matrix4.identity().scaled(_scale),
                      )))),
          Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Center(
                  child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 1000),
                      opacity: 0.0,
                      curve: Curves.easeOutCirc,
                      child: Container(
                        height: 1,
                        width: 1,
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(1)),
                        transform: Matrix4.identity().scaled(_maxScale()),
                      )))),
          Center(
              child: ChildSizeDetector(
                  onChange: (size) {
                    _size = max(size.height, size.width);
                  },
                  child: widget.child))
        ]));
  }
}
