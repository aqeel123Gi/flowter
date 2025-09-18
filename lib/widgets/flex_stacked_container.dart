import 'package:flutter/material.dart';
import '../classes/transform_data/transform_data.dart';
import 'animate/animate.dart';
import 'child_size_detector/child_size_detector.dart';


class FlexStackedContainerController{
  double topEdge = 0;
  double leftEdge = 0;
  double rightEdge = 0;
}

class FlexStackedContainer extends StatefulWidget {

  const FlexStackedContainer({
    super.key,
   required this.parentSize,
   required this.controller,
   required this.maxHeightWhenCentered,
   required this.maxHeightWhenBottomed,
   required this.bottomed,
   required this.maxWidth,
   required this.width,
   required this.backgroundColor,
   required this.radius,
   required this.shadow,
   required this.animateController,
   required this.startFrom,
   required this.endTo,
   required this.show,
   required this.margin,
   required this.child
});


  final Size parentSize;
  final FlexStackedContainerController controller;
  final double maxHeightWhenCentered;
  final double maxHeightWhenBottomed;
  final bool bottomed;
  final double maxWidth;
  final double width;
  final Color backgroundColor;
  final double radius;
  final BoxShadow shadow;
  final AnimateController animateController;
  final bool show;
  final TransformData startFrom;
  final TransformData endTo;
  final EdgeInsets? margin;
  final Widget child;

  @override
  State<FlexStackedContainer> createState() => _FlexStackedContainerState();

}

class _FlexStackedContainerState extends State<FlexStackedContainer>{


  double _height = 0;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    double maxWidth = widget.maxWidth<widget.width?widget.maxWidth:widget.width;


    widget.controller.topEdge = widget.bottomed ? (widget.parentSize.height-_height) : (widget.parentSize.height*0.5)-(_height*0.5)+(widget.margin==null?0:widget.margin!.top*0.5);
    widget.controller.leftEdge = widget.parentSize.width-maxWidth*0.5;
    widget.controller.rightEdge = widget.parentSize.width*0.5+maxWidth*0.5;

    return Stack(children:[
      Positioned(
        top: widget.bottomed?null:0,
        bottom: 0,//(MediaQuery.of(context).viewInsets.bottom),
        left: 0,
        right: 0,
        child:Animate(
        controller: widget.animateController,
        startFrom: widget.startFrom,
        endTo: widget.endTo,
        show: widget.show,
        child: Center(child:AnimatedContainer(

            curve: Curves.easeOutExpo,
            margin: widget.margin==null?EdgeInsets.zero:widget.margin!,
            duration: const Duration(milliseconds: 1000),
                constraints: BoxConstraints(
                  maxWidth: widget.maxWidth,
                ),
                height: _height,
                width: widget.width,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: widget.bottomed?BorderRadius.only(
                        topLeft: Radius.circular(widget.radius),
                        topRight: Radius.circular(widget.radius)
                    ):BorderRadius.circular(widget.radius),
                    color: widget.backgroundColor,
                    boxShadow: [widget.shadow]
                ),
                child:ChildSizeDetector(
                maxLength: (widget.bottomed?widget.maxHeightWhenBottomed:widget.maxHeightWhenCentered)-(widget.margin==null?0:widget.margin!.top+widget.margin!.bottom),
                onChange: (size){
                  setState((){
                    _height = size.height;
                    // _width = widget.maxWidth<size.width?widget.maxWidth:size.width;
                  });
                },
                child:widget.child)
        )))
    )]);
  }
}
