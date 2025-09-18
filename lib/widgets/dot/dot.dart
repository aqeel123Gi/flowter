import 'package:flutter/cupertino.dart';

class Dot extends StatelessWidget {
  const Dot({super.key, required this.color, required this.size, this.duration = Duration.zero, this.curve = Curves.linear});

  final Duration duration;
  final Curve curve;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
