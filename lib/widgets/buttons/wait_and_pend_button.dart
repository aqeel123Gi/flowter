import 'package:flutter/material.dart';
import '../animated_transform_switcher/animated_transform_switcher.dart';
import '../child_size_detector/child_size_detector.dart';
import '../pending.dart';


class PendingWait extends StatefulWidget{

  const PendingWait({
    super.key,
    required this.waiting,
    required this.waitingWidget,
    this.pendingTouchAndBack = true,
    required this.child,
  });

  final bool waiting;
  final Widget waitingWidget;
  final Widget child;
  final bool pendingTouchAndBack;

  @override
  createState() => _PendingWaitState();

}


class _PendingWaitState extends State<PendingWait> {

  bool _pending = false;
  double _height = 100;

  @override
  Widget build(BuildContext context) {


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(!_pending && widget.waiting){
        _pending = true;
        Pending.show(context: context, child: const SizedBox(), backgroundColor: Colors.white.withValues(alpha:0.2));
      }else if(_pending && !widget.waiting){
        _pending = false;
        Pending.hide();
      }
    });


    return SizedBox(height:_height,child:AnimatedTransformingSwitcher(
        switcher:widget.waiting,
        duration: const Duration(milliseconds: 300),
        builder:(context, switcherKey)=>widget.waiting?
        Center(child:widget.waitingWidget):
        ChildSizeDetector(onChange:(size){
          setState(() {
            _height = size.height;
          });
        },child:widget.child)
    ));
  }

}