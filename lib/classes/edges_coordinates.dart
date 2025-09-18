import 'package:flutter/cupertino.dart';

class EdgesCoordinates{

  EdgesCoordinates({
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });

  double top;
  double bottom;
  double left;
  double right;

  void expand(double amount){
    top -= amount;
    bottom += amount;
    left -= amount;
    right += amount;
  }

  Size getSize ()=> Size(right-left,bottom-top);


  static EdgesCoordinates all(double amount)=>EdgesCoordinates(
    top: amount,bottom: amount,left: amount,right: amount
  );

  @override
  String toString() {
    return "EdgesCoordinates ( Top: $top, Bottom: $bottom, Left: $left, Right: $right )";
  }
}


EdgesCoordinates? getEdgesFromKey(GlobalKey key, {double edgesExpand = 0, double modifyPositionScalingByParentScale = 1}){
  try{
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);


    EdgesCoordinates edges = EdgesCoordinates(
        top: (offset.dy/modifyPositionScalingByParentScale)-edgesExpand,
        bottom: (offset.dy/modifyPositionScalingByParentScale)+size.height+edgesExpand,
        left: (offset.dx/modifyPositionScalingByParentScale)-edgesExpand,
        right: (offset.dx/modifyPositionScalingByParentScale)+size.width+edgesExpand
    );
    return edges;
  }catch(e){
    return null;
  }
}

double? getTopEdge(GlobalKey key){
  try{
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero).dy;
  }catch(e){
    return null;
  }
}

Offset? getCenterPointOfWidgetPosition(GlobalKey key,[double modifyPositionScalingByParentScale = 1]){
  EdgesCoordinates? edges = getEdgesFromKey(key,modifyPositionScalingByParentScale: modifyPositionScalingByParentScale);
  if(edges==null){
    return null;
  }else{
    return Offset((edges.left)+((edges.right-(edges.left))/2),(edges.top)+((edges.bottom-(edges.top))/2));
  }
}


