import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class PublicListener extends StatelessWidget{


  static PointerDownEvent? pointerDownEvent;
  static PointerUpEvent? pointerUpEvent;
  static PointerMoveEvent? pointerMoveEvent;
  static PointerHoverEvent? pointerHoverEvent;


  static List<void Function(PointerDownEvent pointerDownEvent)> onDownListeners = [];
  static List<void Function(PointerUpEvent pointerUpEvent)> onUpListeners = [];
  static List<void Function(PointerMoveEvent pointerMoveEvent)> onMoveListeners = [];
  static List<void Function(PointerHoverEvent pointerHoverEvent)> onHoverListeners = [];


  static addOnDownListener(void Function(PointerDownEvent pointerDownEvent) function)=>onDownListeners.add(function);
  static removeOnDownListener(void Function(PointerDownEvent pointerDownEvent) function)=>onDownListeners.removeWhere((e)=>e==function);


  static addOnUpListener(void Function(PointerUpEvent pointerUpEvent) function)=>onUpListeners.add(function);
  static removeOnUpListener(void Function(PointerUpEvent pointerUpEvent) function)=>onUpListeners.removeWhere((e)=>e==function);


  static addOnMoveListener(void Function(PointerMoveEvent pointerMoveEvent) function)=>onMoveListeners.add(function);
  static removeOnMoveListener(void Function(PointerMoveEvent pointerMoveEvent) function)=>onMoveListeners.removeWhere((e)=>e==function);


  static addOnHoverListener(void Function(PointerHoverEvent pointerHoverEvent) function)=>onHoverListeners.add(function);
  static removeOnHoverListener(void Function(PointerHoverEvent pointerHoverEvent) function)=>onHoverListeners.removeWhere((e)=>e==function);



  final Widget child;
  const PublicListener({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (p){
        pointerDownEvent = p;
        for (var element in onDownListeners) {element(p);}
      },
      onPointerUp: (p){
        pointerUpEvent = p;
        for (var element in onUpListeners) {element(p);}
      },
      onPointerMove: (p){
        pointerMoveEvent = p;
        for (var element in onMoveListeners) {element(p);}
      },
      onPointerHover: (p){
        pointerHoverEvent = p;
        for (var element in onHoverListeners) {element(p);}
      },
      child: child
    );
  }
}