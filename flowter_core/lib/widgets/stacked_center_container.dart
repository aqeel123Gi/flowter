import 'package:flutter/material.dart';
import '../classes/transform_data/transform_data.dart';
import 'animate/animate.dart';
import 'child_size_detector/child_size_detector.dart';

class StackedCenteredContainer extends StatefulWidget {

  const StackedCenteredContainer({
    super.key,
   required this.maxHeight,
   required this.maxWidth,
   required this.width,
   required this.decoration,
   required this.animateController,
   required this.startFrom,
   required this.endTo,
   required this.show,
   required this.child
});


  final double maxHeight;
  final double maxWidth;
  final double width;
  final BoxDecoration decoration;
  final AnimateController animateController;
  final bool show;
  final TransformData startFrom;
  final TransformData endTo;
  final Widget child;

  @override
  State<StackedCenteredContainer> createState() => _StackedCenteredContainerState();

}

class _StackedCenteredContainerState extends State<StackedCenteredContainer> {




  double _height = 0;


  @override
  Widget build(BuildContext context) {
    return Stack(children:[AnimatedPositioned(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
        top: 0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child:Animate(
        controller: widget.animateController,
        startFrom: widget.startFrom,
        endTo: widget.endTo,
        show: widget.show,
        child: Center(child:AnimatedContainer(
          clipBehavior: Clip.antiAlias,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutExpo,
          constraints: BoxConstraints(
              // maxHeight: widget.maxHeight,
              maxWidth: widget.maxWidth,
          ),
            height: _height,
            width: widget.width,
            decoration: widget.decoration,
            child:ChildSizeDetector(
                maxLength: widget.maxHeight,
                onChange: (size){
                  setState((){
                    _height = size.height;
                    // _width = widget.maxWidth<size.width?widget.maxWidth:size.width;
                  });
                },
                child:widget.child)
        )
    )))]);
  }
}
