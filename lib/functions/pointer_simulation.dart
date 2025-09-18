part of 'functions.dart';



void pointerSimulationOnCenter(GlobalKey buttonKey, PointerType type, [double scale = 1]) {

  if(buttonKey.currentContext == null){
    if (kDebugMode) {
      print("Key to be tapped is not in the context");
    }
    return;
  }


  final RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
  final Offset position = renderBox.localToGlobal(Offset.zero);
  final Size size = renderBox.size;
  final Offset center = position + size.center(Offset.zero)*scale;


  final PointerDownEvent downEvent = PointerDownEvent(
    position: center,
    kind: PointerDeviceKind.touch,
  );


  final PointerUpEvent upEvent = PointerUpEvent(
    position: center,
    kind: PointerDeviceKind.touch,
  );


  if(type == PointerType.tap){
    GestureBinding.instance.handlePointerEvent(downEvent);
    GestureBinding.instance.handlePointerEvent(upEvent);
  }else if(type == PointerType.down){
    GestureBinding.instance.handlePointerEvent(downEvent);
  }else if(type == PointerType.up){
    GestureBinding.instance.handlePointerEvent(upEvent);
  }


}