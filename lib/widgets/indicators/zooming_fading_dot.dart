import 'package:flutter/material.dart';

class ZoomingFadingDotIndicator extends StatefulWidget {


  const ZoomingFadingDotIndicator({
    super.key,
    required this.size,
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.linear,
    required this.color,
    this.reversed = false,
  });

  final double size;
  final Duration duration;
  final Curve curve;
  final Color color;
  final bool reversed;

  @override
  State<ZoomingFadingDotIndicator> createState() => _ZoomingFadingDotIndicatorState();
}

class _ZoomingFadingDotIndicatorState extends State<ZoomingFadingDotIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: false);

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          alignment: Alignment.center,
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}