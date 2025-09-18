import 'dart:math';
import 'package:flutter/material.dart';


class CircularChart extends StatefulWidget {



  const CircularChart({
    super.key,
    required this.text,
    required this.titleTextStyle,
    required this.percentage,
    required this.count,
    this.duration = const Duration(milliseconds: 2000),
    this.curve = Curves.easeOutCirc,
    this.strokeWidth = 18,
    this.primaryStrokeColor = Colors.blue,
    this.secondaryStrokeColor = Colors.grey, required this.numberTextStyle, required this.percentageTextStyle


  });

  @override
  createState() => _CircularChartState();

  final String text;
  final TextStyle titleTextStyle;
  final TextStyle numberTextStyle;
  final TextStyle percentageTextStyle;

  final Duration duration;
  final Curve curve;

  final double percentage;
  final int count;

  final double strokeWidth;
  final Color primaryStrokeColor;
  final Color secondaryStrokeColor;
}

class _CircularChartState extends State<CircularChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;



  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: [
            // Opacity(
            //   opacity: 0.25,
            //   child: Padding(
            //     padding: const EdgeInsets.only(top:7.0),
            //     child: CustomPaint(
            //         foregroundPainter: CircularChartPainter(_animation.value, widget.strokeWidth, widget.primaryStrokeColor, widget.secondaryStrokeColor),
            //         size: const Size(150, 150),
            //       ),
            //
            //   ),
            // ),
            CustomPaint(
              foregroundPainter: CircularChartPainter(_animation.value, widget.strokeWidth, widget.primaryStrokeColor, widget.secondaryStrokeColor),
              size: const Size(150, 150),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Padding(
                    padding: const EdgeInsets.only(top:10),
                    child: Text(
                      '${(_animation.value * widget.count / widget.percentage).round()}',
                      style: widget.numberTextStyle, textAlign: TextAlign.center,
                    ),
                  )
                ],),
            )
          ],
        ),
        const SizedBox(height: 15,),
        Text(
          widget.text,
          style: widget.titleTextStyle, textAlign: TextAlign.center,
        ),
        Text(
          '${widget.percentage.toStringAsFixed(0)}%',
          style: widget.percentageTextStyle, textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class CircularChartPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color primaryStrokeColor;
  final Color secondaryStrokeColor;

  CircularChartPainter(this.percentage,this.strokeWidth,
  this.primaryStrokeColor,
  this.secondaryStrokeColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = primaryStrokeColor
      ..style = PaintingStyle.stroke;
      // ..strokeCap = StrokeCap.square;

    Paint backgroundPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = secondaryStrokeColor
      ..style = PaintingStyle.stroke;
      // ..strokeCap = StrokeCap.square;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 10;

    canvas.drawCircle(center, radius, backgroundPaint);
    double sweepAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}