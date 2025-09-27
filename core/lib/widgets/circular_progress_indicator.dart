import 'package:flowter/functions/post_state.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'center_regardless_layout/center_regardless_size.dart';

class CircularCounter extends StatefulWidget {
  final Color baseColor;
  final Color color;
  final double width;
  final double size;
  final int currentCount;
  final int totalCount;
  final Duration duration;
  final Curve curve;
  final TextStyle textStyle;
  final double numberVerticalShift;
  final bool clockwise; // إضافة خاصية clockwise

  const CircularCounter({
    super.key,
    required this.baseColor,
    required this.color,
    required this.width,
    required this.size,
    required this.currentCount,
    required this.totalCount,
    required this.duration,
    required this.curve,
    required this.textStyle,
    required this.numberVerticalShift,
    this.clockwise = true, // القيمة الافتراضية هي true
  });

  @override
  createState() => _CircularCounterState();
}

class _CircularCounterState extends State<CircularCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    addPostFrameCallback(() {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CircularCounter oldWidget) {
    if (oldWidget.currentCount != widget.currentCount) {
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: CircularPainter(
              baseColor: widget.baseColor,
              color: widget.color,
              width: widget.width,
              progress: widget.currentCount == 0
                  ? 0
                  : _animation.value *
                      (widget.currentCount / widget.totalCount),
              clockwise: widget.clockwise, // تمرير خاصية clockwise
            ),
            child: CenterRegardlessLayout(
              verticalShift: widget.numberVerticalShift,
              child: Text(
                '${widget.currentCount}',
                style: widget.textStyle,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CircularPainter extends CustomPainter {
  final Color baseColor;
  final Color color;
  final double width;
  final double progress;
  final bool clockwise; // إضافة خاصية clockwise

  CircularPainter({
    required this.baseColor,
    required this.color,
    required this.width,
    required this.progress,
    required this.clockwise, // استلام الخاصية
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint baseCircle = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    Paint progressCircle = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    double radius = (size.width - width) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, baseCircle);

    double sweepAngle = 2 * pi * progress;

    if (!clockwise) {
      sweepAngle = -sweepAngle;
    }

    for (int i = 0; i < 2; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        progressCircle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
