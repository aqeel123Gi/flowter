import 'dart:math';
import 'package:flutter/material.dart';

class CircularMovement extends StatefulWidget {
  final Widget child;
  final double initDirection; // In radians
  final double speed; // In radians per second
  final double diameter;
  final Duration duration;
  final Curve curve;

  const CircularMovement({
    super.key,
    required this.initDirection,
    required this.speed,
    required this.diameter,
    required this.duration,
    required this.curve,
    required this.child,
  });

  @override
  createState() => _CircularMovementState();
}

class _CircularMovementState extends State<CircularMovement>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleAnimation;
  late AnimationController _diameterController;
  late Animation<double> _diameterAnimation;

  @override
  void initState() {
    super.initState();

    // Calculate the duration based on the speed
    double durationInSeconds = (2 * pi) / widget.speed;

    _controller = AnimationController(
      duration: Duration(seconds: durationInSeconds.round()),
      vsync: this,
    )..repeat();

    _angleAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _diameterController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _diameterAnimation = Tween<double>(begin: widget.diameter, end: widget.diameter).animate(
      CurvedAnimation(
        parent: _diameterController,
        curve: widget.curve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _diameterController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CircularMovement oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.diameter != oldWidget.diameter) {
      _diameterController.reset();
      _diameterAnimation = Tween<double>(begin: oldWidget.diameter, end: widget.diameter).animate(
        CurvedAnimation(
          parent: _diameterController,
          curve: widget.curve,
        ),
      )..addListener(() {
        setState(() {});
      });
      _diameterController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    double angle = _angleAnimation.value + widget.initDirection;
    double radius = _diameterAnimation.value / 2;

    double x = radius * cos(angle);
    double y = radius * sin(angle);

    return Center(
      child: Transform.translate(
        offset: Offset(x, y),
        child: widget.child,
      ),
    );
  }
}