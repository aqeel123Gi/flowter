import 'dart:math';
import 'package:flutter/material.dart';
import '../functions/functions.dart';
import 'child_size_detector/child_size_detector.dart';

class LightFocus extends StatefulWidget {
  const LightFocus({
    super.key,
    this.active = true,
    this.ratioOfChildSize = 1,
    this.ms = 500,
    this.curve = Curves.easeInOut,
    required this.color,
    required this.child,
  });

  final bool active;
  final double ratioOfChildSize;
  final int ms;
  final Curve curve;
  final Color color;
  final Widget child;

  @override
  State<LightFocus> createState() => _AnimatedTransformState();
}

class _AnimatedTransformState extends State<LightFocus> {


  double _scale = 0;
  double _opacity = 0.0;


  bool _inLoop = false;


  @override
  Widget build(BuildContext context) {

    if(!_inLoop && widget.active){
      _inLoop = true;
      loopExecution(
          function: ()async{
            if(mounted) {
              setState(() {
                _opacity = _opacity==1?0:1;
              });
            }
          },
          breakDuration: Duration(milliseconds: widget.ms),
          stopOn: (){
            if(!mounted){
              return true;
            }
            if(!widget.active){
              _inLoop = false;
              setState((){
                _opacity = 0.0;
              });
              return true;
            }
            return false;
          });
    }

    return Stack(
            children: [
              Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(child: AnimatedOpacity(
                      duration: Duration(milliseconds:widget.ms),
                      opacity: _opacity,
                      curve: widget.curve,
                      child: Container(
                        height: 1,
                        width: 1,
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(1)
                        ),
                        transform: Matrix4.identity().scaled(_scale*widget.ratioOfChildSize),
                      )))),
              Center(child: ChildSizeDetector(
                  onChange: (size){
                    _scale = max(size.height,size.width);
                  },
                  child: widget.child
              ))
            ]);
  }
}
