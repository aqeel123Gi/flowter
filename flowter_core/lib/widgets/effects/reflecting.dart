import 'dart:math';

import 'package:flutter/material.dart';

class ReflectionWidget extends StatelessWidget {

  final double shift;
  final Widget child;

  const ReflectionWidget({super.key, required this.child, this.shift = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:shift),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
          const SizedBox(height: 30),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(pi),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha:0.8),
                    Colors.transparent,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Opacity(
                opacity: 0.5,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}