import 'package:flutter/material.dart';

class RelativePadding extends StatelessWidget{

  const RelativePadding({
    super.key,
    required this.padding,
    required this.child
  });

  final EdgeInsets Function(Size parentSize) padding;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (_,c)=>Padding(padding: padding(Size(c.maxWidth,c.maxHeight)),child:child));

}