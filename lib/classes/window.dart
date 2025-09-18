import 'dart:math';
import 'package:flutter/cupertino.dart';

class Window{

  static double Function() _scaleFrom = ()=>1;

  static void setScaleFrom(double Function() scaleFrom){
    _scaleFrom = scaleFrom;
  }

  static double width(BuildContext context) => MediaQuery.of(context).size.width*(1/_scaleFrom());
  static double height(BuildContext context) => MediaQuery.of(context).size.height*(1/_scaleFrom());

  static double minLength(BuildContext context) => min(width(context), height(context));

  static double topPadding(BuildContext context) => MediaQuery.of(context).padding.top*(1/_scaleFrom());
  static double bottomPadding(BuildContext context) => MediaQuery.of(context).padding.bottom*(1/_scaleFrom());

  static double insetsBottom(BuildContext context) => MediaQuery.of(context).viewInsets.bottom*(1/_scaleFrom());
  static double insetsBottomX(BuildContext context) => MediaQuery.of(context).systemGestureInsets.bottom*(1/_scaleFrom());

  static Offset centerOfWindow(BuildContext context) => Offset(width(context)/2, height(context)/2);

}