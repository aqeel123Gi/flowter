import 'package:flutter/material.dart';

Future<T> showTransparentPage<T>(BuildContext context,Widget widget,{bool back = true,String? routeName}) async{
  return await Navigator.of(context).push(PageRouteBuilder(
      fullscreenDialog: true,
      transitionDuration: const Duration(seconds: 1),
      reverseTransitionDuration: const Duration(seconds: 1),
      settings: RouteSettings(name: routeName),
      opaque: false,
      pageBuilder: (context,a1,a2)=>Directionality(
          textDirection: Directionality.of(context),
          child:PopScope(
              onPopInvokedWithResult: (_,__)async=>back,
              child:Material(color: Colors.transparent,child:widget)
          )
      )
  ));
}

void blankTouch (BuildContext context) {
  showTransparentPage(context,const SizedBox(),back: false);
}