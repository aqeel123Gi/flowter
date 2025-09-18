import 'package:flutter/cupertino.dart';

class ChildSizeDetector extends StatefulWidget {
  final Widget child;
  final void Function(Size newSize) onChange;
  final Axis flexibleAxis;
  final bool reversed;
  final double maxLength;
  const ChildSizeDetector({
    super.key,
    required this.onChange,
    required this.child,
    this.flexibleAxis = Axis.vertical,
    this.reversed = false,
    this.maxLength = double.infinity
  });

  @override
  createState() => _ChildSizeDetectorState();
}

class _ChildSizeDetectorState extends State<ChildSizeDetector> {

  bool initialized = false;
  final GlobalKey _key = GlobalKey();
  Size? _oldSize;

  @override
  void initState() {
    super.initState();
    _checkSize();
  }

  @override
  Widget build(BuildContext context) {
    _checkSize();
    return SingleChildScrollView(
      scrollDirection: widget.flexibleAxis,
        reverse: widget.reversed,
        padding: EdgeInsets.zero,
    child:Container(
          key: _key,
      constraints: BoxConstraints(
        maxHeight: widget.flexibleAxis==Axis.vertical?widget.maxLength:double.infinity,
        maxWidth: widget.flexibleAxis==Axis.horizontal?widget.maxLength:double.infinity
      ),
      child: widget.child));
  }


  void _checkSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted){
        setState((){});
        var context = _key.currentContext;
        if (context == null) return;

        Size newSize = context.size!;
        if (_oldSize == newSize) return;

        _oldSize = newSize;
        widget.onChange(newSize);
        setState((){});
      }
    });
  }
}


class AnimatedFlexibleSize extends StatefulWidget {
  const AnimatedFlexibleSize({
    super.key,
    this.flexibleAxis = Axis.vertical,
    this.maxLength = double.infinity,
    this.reversed = false,
    required this.child,
  });

  final Widget child;
  final Axis flexibleAxis;
  final double maxLength;
  final bool reversed;

  @override
  State<AnimatedFlexibleSize> createState() => _AnimatedFlexibleSizeState();
}

class _AnimatedFlexibleSizeState extends State<AnimatedFlexibleSize> {

  double _length = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCirc,
        height: widget.flexibleAxis == Axis.vertical?_length:null,
        width: widget.flexibleAxis == Axis.horizontal?_length:null,
        child:ChildSizeDetector(
          reversed: widget.reversed,
          maxLength: widget.maxLength,
          flexibleAxis: widget.flexibleAxis,
          onChange: (size){
            setState(() {
              _length = widget.flexibleAxis == Axis.vertical?size.height:size.width;
            });
          },
          child: widget.child,
    ));
  }
}



class AnimatedWidgetShowing extends StatefulWidget {
  const AnimatedWidgetShowing({
    super.key,
    required this.shown,
    required this.opacity,
    this.axis = Axis.vertical,
    required this.child
  });

  final bool shown;
  final bool opacity;
  final Axis axis;
  final Widget child;


  @override
  State<AnimatedWidgetShowing> createState() => _AnimatedWidgetShowingState();
}

class _AnimatedWidgetShowingState extends State<AnimatedWidgetShowing> {

  double _length = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCirc,
        height: widget.axis == Axis.vertical?(widget.shown?_length:0):null,
        width: widget.axis == Axis.horizontal?(widget.shown?_length:0):null,
        child:ChildSizeDetector(
          flexibleAxis:widget.axis,
          onChange: (size){
            setState(() {
              _length = widget.axis == Axis.vertical?size.height:size.width;
            });
          },
          child: widget.child,
        ));
  }
}

