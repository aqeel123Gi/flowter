import 'package:flutter/material.dart';
import '../../functions/post_state.dart';

class OnInitChild extends StatefulWidget {
  const OnInitChild({
    super.key,
    this.onInit,
    this.onBuilt,
    required this.child
  });

  final void Function()? onInit;
  final void Function()? onBuilt;
  final Widget child;

  @override
  State<OnInitChild> createState() => _OnInitChildState();
}

class _OnInitChildState extends State<OnInitChild> {


  @override
  void initState() {
    widget.onInit?.call();
    addPostFrameCallback((){
      widget.onBuilt?.call();
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
