import 'package:framework/framework.dart';
import 'package:flutter/material.dart';

class AnimateController{

  static final Map<String,AnimateController> _controllers = {};
  static showByID(String key){
    _controllers[key]?.show();
  }
  static hideByID(String key){
    _controllers[key]?.hide();
  }
  static startOneByOneByID<T>(String staticSubID, List<T> list,int milliseconds){

    executeOneByOne<T>(list, Duration(milliseconds: milliseconds), (e) {
      if(_controllers.containsKey(staticSubID+e.toString())){
        AnimateController.showByID(par(staticSubID+e.toString(),"SHOW"));
      }
    });
  }

  static endOneByOneByID<T>(String staticSubID, List<T> list,int milliseconds){

    executeOneByOne<T>(list, Duration(milliseconds: milliseconds), (e) {
      if(_controllers.containsKey(staticSubID+e.toString())){
        AnimateController.hideByID(staticSubID+e.toString());
      }
    });

  }


  static AnimateController setNewID([String? id]){

    id ??= Generator.getKey(length: 20);

    if(_controllers.containsKey(id)){
      return _controllers[id]!;
    }
    return AnimateController()..setIDIfNull(id);
  }


  String? id;
  List<AnimateController> _children = [];


  void setIDIfNull(String id){
    if(_controllers.containsKey(this.id)){
      _controllers.remove(this.id);
    }
    this.id = id;
    _controllers[id] = this;
  }


  initialize (void Function () show, void Function () hide){
    this.show = show;
    this.hide = hide;
  }


  initializeChildren (List<AnimateController> controllers){
    _children = controllers;
  }


  addChild (AnimateController controller){
    _children.add(controller);
  }


  void setItAsChild (AnimateController parent){
    parent.addChild(this);
  }


  showChildren (){
    for (var element in _children) {
      element.show();
    }
  }


  hideChildren (){
    for (var element in _children) {
      element.hide();
    }
  }


  void Function () show = (){
    throw Exception("No Animate Widget attached.");
  };
  void Function () hide = (){
    throw Exception("No Animate Widget attached.");
  };

}

mixin EmbeddedAnimate{
  final AnimateController animateController = AnimateController();
}

class Animate extends StatefulWidget {



  @override
  createState() => _AnimateState();

  const Animate({
    super.key,
    this.controller,
    this.show = false,
    this.showAfter = Duration.zero,
    this.startFrom,
    this.endTo,
    required this.child
  });

  final AnimateController? controller;
  final TransformData? startFrom;
  final TransformData? endTo;
  final Widget child;
  final bool show;
  final Duration showAfter;

}

class _AnimateState extends State<Animate> {

  late TransformData _currentAnimatedTransformData;

  isShown(){
    return _currentAnimatedTransformData.x==0 && _currentAnimatedTransformData.y==0 && _currentAnimatedTransformData.opacity==1;
  }

  show(){

    if(mounted){
      Future.delayed(widget.showAfter,(){
        if(mounted) {
          setState(() {
            _currentAnimatedTransformData = widget.startFrom!.copyWith(duration:Duration.zero, ignorance: false);
          });
          addPostFrameCallback(() {
            if (mounted) {

              setState(() {
                _currentAnimatedTransformData = widget.startFrom!.copyWith(
                    ignorance: false,
                    forwardedX:0.0,
                    x:0.0,
                    y:0.0,
                    opacity:1.0,
                    scale: 1.0
                );
              });

              if(widget.controller!=null){
                widget.controller!.showChildren();
              }


            }
          });
        }
      });
    }
  }

  hide(){
    if(mounted && widget.endTo!=null){
      setState(() {
        _currentAnimatedTransformData = widget.endTo!;
      });
      if(widget.controller!=null) {
        widget.controller!.hideChildren();
      }
    }
  }

  @override
  void initState() {
    if(widget.controller!=null) {
      widget.controller!.initialize(show, hide);
    }
    if(widget.startFrom!=null){
      _currentAnimatedTransformData = widget.startFrom!.copyWith(ignorance: true);
    }else if(widget.endTo!=null){
      _currentAnimatedTransformData = TransformData(opacity: 1);
    }else{
      throw Exception("No AnimatedTransformData implemented.");
    }

    if(widget.show){
      addPostFrameCallback(() {
        show();
      });
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedTransform(
      data: _currentAnimatedTransformData,
      child: widget.child);
  }

}