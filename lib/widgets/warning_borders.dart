import 'package:flutter/material.dart';
import '../classes/transform_data/transform_data.dart';
import '../functions/functions.dart';
import 'animated_transform/animated_transform.dart';


class WarningBorders extends StatefulWidget {
  const WarningBorders({
    super.key,
    required this.child,
    required this.radius,
    required this.width,
    required this.color,
  });

  final Widget child;
  final double radius;
  final double width;
  final Color color;




  @override
  State<WarningBorders> createState() => _WarningBordersState();
}

class _WarningBordersState extends State<WarningBorders> {

  @override
  void initState() {
    super.initState();
    loopExecution(function: ()async{
        if(mounted){
          setState(() {
            _opacity=_opacity==0?1:0;
          });
        }
      },
      breakDuration: const Duration(seconds: 1),
      stopOn: ()=>!mounted);
  }

  double _opacity = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child,
      AnimatedTransform(
        data: TransformData(opacity: _opacity,curve: Curves.easeInOutQuad,duration: const Duration(seconds: 1)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: widget.color,width: widget.width),
            borderRadius: BorderRadius.circular(widget.radius)
          ),
        ),
      ),

    ]);
  }
}
