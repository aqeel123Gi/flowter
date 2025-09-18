import 'package:flutter/material.dart';

class FilledStackedButton extends StatelessWidget{

  final void Function()? onPressed;
  final Color foregroundColor;
  final Widget? child;

  const FilledStackedButton({
    super.key,
    required this.onPressed,
    this.foregroundColor = Colors.blue,
    this.child,
  });

  @override
  Widget build(BuildContext context) => onPressed==null?const SizedBox():Positioned(
      top: 0,bottom: 0,left: 0,right: 0,
      child: TextButton(
        style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap,foregroundColor: foregroundColor),
        onPressed: onPressed!,
        child:child??const SizedBox()
      ));

}


class FilledButtonAsset extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final Color foregroundColor;
  final Widget? child;

  const FilledButtonAsset({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.foregroundColor = Colors.blue,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(

        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          shape: const RoundedRectangleBorder(),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: foregroundColor,
          padding: EdgeInsets.zero
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
        child:child??const SizedBox()
    );
  }
}
