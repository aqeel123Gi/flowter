import 'dart:math';
import 'package:framework/classes/circular_offset/circular_offset.dart';
import 'package:framework/classes/transform_data/transform_data.dart';
import 'package:flutter/material.dart';
import '../animated_transform/animated_transform.dart';
import '../buttons/full_stacked_button.dart';


class PrintedPhoto extends StatefulWidget {


  const PrintedPhoto({
    super.key,
    this.rotation,
    this.borderColor = Colors.white,
    this.centerColor = const Color(0xffcccccc),
    this.shadowColor = const Color(0x30000000),
    this.overlayColor,
    required this.borderWidth,
    this.shadowBlur = 0,
    this.onPressed,
    required this.child,
  });


  final double? rotation;
  final void Function()? onPressed;
  final Color borderColor;
  final Color centerColor;
  final Color shadowColor;
  final Color? overlayColor;
  final double borderWidth;
  final double shadowBlur;
  final Widget child;

  @override
  State<PrintedPhoto> createState() => _PrintedPhotoState();
}

class _PrintedPhotoState extends State<PrintedPhoto> {

  late double _rotation;

  @override
  void initState() {
    _rotation = widget.rotation??((Random().nextDouble()-0.5)*pi*0.3);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return
      AnimatedTransform(
      data: TransformData(rotation: _rotation,opacity: 1.0),
      child:
        Stack(children:[
          Container(
        decoration: BoxDecoration(
          color: widget.borderColor,
          boxShadow: [BoxShadow(
            color: widget.shadowColor,
            offset: CircularOffset(-_rotation+pi/2,10).xyOffset,
            blurRadius: widget.shadowBlur
          )]
        ),
        padding: EdgeInsets.all(widget.borderWidth),
        child: Container(
          color: widget.centerColor,
          child: widget.child
      )),
        FilledStackedButton(
            foregroundColor: widget.overlayColor??widget.borderColor,
            onPressed: widget.onPressed)
        ])
      
    );
  }
}
