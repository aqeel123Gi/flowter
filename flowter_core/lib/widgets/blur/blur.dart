import 'dart:ui';
import 'package:flutter/material.dart';
import '../../controllers/this_device/this_device.dart';


class Blur extends StatelessWidget{
  const Blur({
    super.key,
    this.child,
    this.radius = 0,
    this.strength = 5,
    this.opacity = 1,
    this.duration = Duration.zero,
    this.curve = Curves.easeOutCirc,
    this.active = true,
  });


  final Widget? child;
  final double radius;
  final double strength;
  final double opacity;
  final Duration duration;
  final Curve curve;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (_){
        if(active && ThisDevice.canHandleHighGraphicalUIOrNone){
            return AnimatedOpacity(
          duration: duration,
          curve: curve,
          opacity: opacity,
          child:ClipRRect(borderRadius: BorderRadius.circular(radius),child:BackdropFilter(
            blendMode: BlendMode.srcATop,
            filter: ImageFilter.blur(sigmaX: strength,sigmaY: strength),
            child: child??const SizedBox(),
          ),));
        }else{
          return child??const SizedBox();
      }
    }
    );
  }
}