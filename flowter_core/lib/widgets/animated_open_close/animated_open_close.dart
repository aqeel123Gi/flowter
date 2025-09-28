import 'package:flowter_core/functions/post_state.dart';
import 'package:flowter_core/widgets/child_size_detector/child_size_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flowter_core/flowter_core.dart';

class AnimatedOpenClose extends StatefulWidget {
  const AnimatedOpenClose(
      {super.key,
      this.axis = Axis.vertical,
      required this.duration,
      required this.curve,
      required this.open,
      required this.child});

  final Axis axis;
  final Duration duration;
  final Curve curve;
  final bool open;
  final Widget child;

  @override
  State<AnimatedOpenClose> createState() => _AnimatedOpenCloseState();
}

class _AnimatedOpenCloseState extends State<AnimatedOpenClose> {
  bool _init = false;
  double _size = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.axis == Axis.vertical
          ? widget.open
              ? _size
              : 0
          : null,
      width: widget.axis == Axis.horizontal
          ? widget.open
              ? _size
              : 0
          : null,
      duration: _init ? widget.duration : Duration.zero,
      curve: widget.curve,
      child: ChildSizeDetector(
          flexibleAxis: widget.axis,
          onChange: (size) {
            setState(() {
              if (widget.axis == Axis.vertical) {
                _size = size.height;
              } else {
                _size = size.width;
              }

              addPostFrameCallback(() {
                setState(() {
                  _init = true;
                });
              });
            });
          },
          child: widget.child),
    );
  }
}
