import 'package:flutter/material.dart';
import '../../functions/functions.dart';
import '../../controllers/this_device/this_device.dart';

class Light extends StatefulWidget {
  const Light({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.speedInMS,
    required this.colors,
    required this.size,
  });

  final double? Function(double stackHeight)? top;
  final double? Function(double stackHeight)? bottom;
  final double? Function(double stackWidth)? left;
  final double? Function(double stackWidth)? right;
  final int speedInMS;
  final List<Color> colors;
  final double Function(Size stackSize) size;

  @override
  State<Light> createState() => _LightState();
}

class _LightState extends State<Light> {

  int index = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loopExecution(function: ()async{
        if(mounted){
          setState(() {
            index++;
            if(index>=widget.colors.length){
              index=0;
            }
          });
        }
      },
          breakDuration: Duration(milliseconds: widget.speedInMS),

          stopOn: ()=>!mounted);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,c){

      double length = widget.size(Size(c.maxWidth,c.maxHeight));

      return Stack(children: [
        Positioned(
            top: widget.top==null?null:widget.top!(c.maxHeight),
            bottom: widget.bottom==null?null:widget.bottom!(c.maxHeight),
            left: widget.left==null?null:widget.left!(c.maxWidth),
            right: widget.right==null?null:widget.right!(c.maxWidth),
            height: length,
            width: length,
            child: ThisDevice.canHandleHighGraphicalUIOrNone?AnimatedContainer(
              duration: Duration(milliseconds: widget.speedInMS),
              transform: Matrix4.identity()..translate(-length/2,-length/2),
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                      center: Alignment.center,
                      colors: [widget.colors[index], widget.colors[index].withValues(alpha:0)],
                      stops: const [0, 1])),
            ):Container(
              transform: Matrix4.identity()..translate(-length/2,-length/2),
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                      center: Alignment.center,
                      colors: [getMixedColor(widget.colors), getMixedColor(widget.colors).withValues(alpha:0)],
                      stops: const [0, 1])),
            ))
      ]);
    });
  }
}