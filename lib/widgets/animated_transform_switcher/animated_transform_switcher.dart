import 'package:framework/classes/transform_data/transform_data.dart';
import 'package:framework/functions/post_state.dart';
import 'package:flutter/material.dart';
import '../animate/animate.dart';



class AnimatedTransformingSwitcher<T> extends StatefulWidget {

  const AnimatedTransformingSwitcher({
    super.key,
    this.startX = 0,
    this.startY = 0,
    this.endX = 0,
    this.endY = 0,
    required this.duration,
    this.showAfterDuration = Duration.zero,
    required this.switcher,
    required this.builder,
  });

  final Duration showAfterDuration;
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final Widget Function(BuildContext context, T switcherKey) builder;
  final T switcher;
  final Duration duration;

  @override
  State<AnimatedTransformingSwitcher<T>> createState() => _AnimatedTransformingSwitcherState<T>();
}

class _AnimatedTransformingSwitcherState<T> extends State<AnimatedTransformingSwitcher<T>> {

  bool init = false;

  late T _currentKey;
  Widget _currentChild = const SizedBox();
  final List<AnimateController> _controllers = [];
  final List<GlobalKey> _keys = [];
  final List<Widget> _children = [];


  @override
  void initState() {
    super.initState();
    addPostFrameCallback(() {
      if(!mounted)return;
      _currentChild = widget.builder(context, widget.switcher);
    });
    _currentKey = widget.switcher;
    _controllers.add(AnimateController.setNewID());
    _keys.add(GlobalKey());
  }

  void _addIfNotTheSame(){

    if(_currentKey != widget.switcher){

      _currentKey = widget.switcher;


      _children.add(IgnorePointer(ignoring:true,child:Animate(
          key: _keys.last,
          controller: _controllers.last,
          startFrom: TransformData(opacity:0, x:widget.startX,y:widget.startY,duration: widget.duration),
          endTo: TransformData(opacity:0, x:widget.endX,y:widget.endY,duration: widget.duration),
          show: true,
          child:_currentChild
      )));

      _currentChild = widget.builder(context, widget.switcher);
      _controllers.add(AnimateController.setNewID());
      _keys.add(GlobalKey());


      int i = _children.length;

      _controllers[i-1].hide();

      Future.delayed(const Duration(milliseconds: 1000),(){
        if(mounted){
          setState(() {
            _children[i-1] = const SizedBox();
          });
        }
      });

    }

  }


  @override
  Widget build(BuildContext context) {

    _addIfNotTheSame();

    return Stack(
        children:[
          Stack(
            children: _children,
          ),
          Animate(
              key: _keys.last,
              show: true,
              showAfter: widget.showAfterDuration,
              controller: _controllers.last,
              startFrom: TransformData(opacity:0, x:widget.startX,y:widget.startY),
              endTo: TransformData(opacity:0, x:widget.endX,y:widget.endY),
              child:widget.builder(context, widget.switcher)
          )
        ]
    );
  }
}