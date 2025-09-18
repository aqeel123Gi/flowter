import 'package:flutter/material.dart';

class AnimatedVisibility extends StatefulWidget{
  const AnimatedVisibility({
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 750),
    super.key
  });

  final Widget child;
  final bool visible;
  final Duration duration;

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility> {

  bool _opacity = false;
  bool _visible = false;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.visible == false && _visible == true){
      _opacity = false;
      Future.delayed(widget.duration,(){
        if(widget.visible == false){
          setState(()=>_visible = false);
        }
      });
    }

    else if(widget.visible == true){
      _visible = true;
      WidgetsBinding.instance.addPostFrameCallback((_){
        setState(() {
          _opacity = true;
        });
      });
    }

    return Visibility(
        visible: _visible,
        child: AnimatedOpacity(
            duration: widget.duration,
            curve: Curves.easeOutCirc,
            opacity: _opacity?1:0,
            child: widget.child
        ));
  }
}