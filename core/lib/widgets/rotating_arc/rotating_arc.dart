import 'package:flutter/material.dart';

class RotatingArc extends StatefulWidget {
  final double size; // حجم الدائرة الخارجية
  final double width; // عرض القوس
  final Color color; // لون القوس
  final Duration speed; // سرعة الدوران

  const RotatingArc({
    super.key,
    required this.size,
    required this.width,
    required this.color,
    required this.speed,
  });

  @override
  State<RotatingArc> createState() => _RotatingArcState();
}

class _RotatingArcState extends State<RotatingArc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.speed,
    )..repeat(); // تكرار الحركة بشكل دائم
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.14159265359, // دوران كامل (360 درجة)
            child: CustomPaint(
              painter: ArcPainter(
                width: widget.width,
                color: widget.color,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double width; // عرض القوس
  final Color color; // لون القوس

  ArcPainter({
    required this.width,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    const double startAngle = 0; // زاوية البداية
    const double sweepAngle = 3.14 / 2; // ربع دائرة (90 درجة)

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - width) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
