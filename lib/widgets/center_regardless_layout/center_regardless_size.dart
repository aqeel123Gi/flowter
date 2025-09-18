import 'package:flutter/cupertino.dart';

class CenterRegardlessLayout extends StatelessWidget{

  const CenterRegardlessLayout({
    super.key,
    required this.child,
    this.verticalShift=0,
    this.horizontalShift=0,
  });
  final Widget child;
  final double verticalShift;
  final double horizontalShift;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(top:-200+verticalShift,bottom: -200,left: -200+horizontalShift,right:-200,child: Center(child:child))
    ]);
  }

}