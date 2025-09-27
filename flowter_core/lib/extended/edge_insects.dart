import 'package:flutter/cupertino.dart';
import 'package:flowter_core/classes/window.dart';

class ExtEdgeInsects extends EdgeInsets{

  ExtEdgeInsects.all(super.value) : super.all();

  static EdgeInsets sumOf(BuildContext context,{
    bool topScreenPadding = false,
    bool bottomScreenPadding = false,
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
    double all = 0,
    vertical = 0,
    horizontal = 0,
    start = 0,
    end = 0
  }) {
    return EdgeInsets.only(
        top: (topScreenPadding?Window.topPadding(context):0) + top + vertical + all,
        left: left + horizontal + (Directionality.of(context) == TextDirection.ltr?start:end) + all,
        right: right + horizontal + (Directionality.of(context) == TextDirection.ltr?start:end) + all,
        bottom: (bottomScreenPadding?Window.bottomPadding(context):0) + bottom + vertical + all
    );
  }

}