import 'package:flutter/material.dart';

class ZoomingClickEffect extends StatefulWidget {
  const ZoomingClickEffect({
    super.key, required this.child,
    this.enabled = true
  });

  final Widget child;
  final bool enabled;

  @override
  State<ZoomingClickEffect> createState() => _ZoomingClickEffectState();
}

class _ZoomingClickEffectState extends State<ZoomingClickEffect> {

  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return  Listener(
      onPointerDown: (_){
        setState(() {
          _scale = 0.95;
        });
      },
      onPointerUp: (_){
        setState(() {
          _scale = 1;
        });
      },
      onPointerCancel: (_){
        setState(() {
          _scale = 1;
        });
      },
      child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transformAlignment: Alignment.center,
              transform: widget.enabled?Matrix4.identity().scaled(_scale):Matrix4.identity(),
              child: widget.child
              )

    );
  }
}
