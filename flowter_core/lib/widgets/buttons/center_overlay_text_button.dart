import 'package:flutter/material.dart';

import '../effects/circular_tap_effect.dart';


class CenterOverlayTextButton extends StatefulWidget{

  const CenterOverlayTextButton({
    super.key,
    required this.text,
    this.textStyle,
    required this.overlayColor,
    required this.onPressed,
  });

  final TextStyle? textStyle;
  final String text;
  final Color overlayColor;
  final void Function()? onPressed;

  @override
  createState() => _CenterOverlayTextButtonState();

}


class _CenterOverlayTextButtonState extends State<CenterOverlayTextButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: CircularTapEffect(
          onPressed: widget.onPressed,
          color: widget.overlayColor,
          child:SizedBox(width: double.maxFinite,child:Text(widget.text,style: widget.textStyle,textAlign: TextAlign.center))
      ));
  }

}