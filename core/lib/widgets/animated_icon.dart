import 'package:flutter/material.dart';

class AnimatedIconX extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final Duration duration;
  final Curve curve;

  const AnimatedIconX({
    super.key,
    required this.icon,
    this.color = Colors.black,
    this.size = 24.0,
    required this.duration,
    required this.curve,
  });

  @override
  createState() => _AnimatedIconXState();
}

class _AnimatedIconXState extends State<AnimatedIconX>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Icon(
          widget.icon,
          color: widget.color,
          size: widget.size * _controller.value,
        );
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}