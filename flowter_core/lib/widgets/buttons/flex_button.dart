import 'package:flutter/material.dart';
import '../animated_transform_switcher/animated_transform_switcher.dart';
import 'full_stacked_button.dart';
import '../child_size_detector/child_size_detector.dart';

class FlexButton extends StatefulWidget{

  const FlexButton({
    super.key,
    this.width = 100,
    required this.height,
    this.waiting = false,
    this.visible = true,
    required this.title,
    required this.decoration,
    required this.onPressed,
    this.waitingChild = const SizedBox(),
  });

  final double width;
  final double height;
  final bool visible;
  final bool waiting;
  final String title;
  final BoxDecoration decoration;
  final void Function()? onPressed;
  final Widget waitingChild;

  @override
  createState() => _FlexButtonState();

}


class _FlexButtonState extends State<FlexButton> {

  bool init = false;
  double _width = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        init=true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: IgnorePointer(ignoring: !widget.visible,child:AnimatedOpacity(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutExpo,
      opacity: widget.visible && init?1:0,
      child: AnimatedTransformingSwitcher(
        duration: const Duration(milliseconds: 300),
          switcher: widget.waiting,
          builder:(context, switcherKey)=>!widget.waiting?AnimatedContainer(
            height: widget.height,
        clipBehavior: Clip.antiAlias,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutExpo,
        decoration: widget.decoration,
        width: widget.width>_width?widget.width:_width,
        child:Stack(children:[
          Center(child:SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          child: ChildSizeDetector(
            onChange: (size){
              setState((){
                _width = size.width;
              });
            },
            child:Padding(padding: const EdgeInsets.all(12),child:Text(widget.title,style: const TextStyle(color: Colors.white,fontSize: 16)))
          ))),

        FilledStackedButton(onPressed: widget.onPressed,foregroundColor: Colors.white,)
      ]
        )):SizedBox(height:widget.height,child:Center(child:widget.waitingChild)))
      )
    ));
  }

}