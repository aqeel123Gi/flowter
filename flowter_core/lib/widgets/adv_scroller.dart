import 'package:flowter_core/functions/post_state.dart';
import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';

class AdvScrollerBuilder extends StatefulWidget {
  const AdvScrollerBuilder({
    super.key,
    required this.visible,
    required this.enabled,
    required this.thumbOnContent,
    required this.thumbBackgroundDecoration,
    required this.margin,
    required this.thumbWidth,
    required this.thumbHeight,
    required this.thumbPadding,
    required this.thumbDecoration,
    required this.thumbDecorationOnHover,
    required this.duration,
    required this.curve,
    required this.scrollController,
    required this.child,
    required this.scrollDirection,
    required this.onStart,
  });

  final bool visible;
  final bool enabled;
  final bool thumbOnContent;
  final double thumbWidth;
  final double thumbHeight;
  final BoxDecoration thumbBackgroundDecoration;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry thumbPadding;
  final BoxDecoration thumbDecoration;
  final BoxDecoration thumbDecorationOnHover;
  final Duration duration;
  final Curve curve;
  final ScrollController scrollController;
  final Widget child;
  final Axis scrollDirection;
  final bool onStart;

  @override
  State<AdvScrollerBuilder> createState() => _AdvScrollerBuilderState();
}

class _AdvScrollerBuilderState extends State<AdvScrollerBuilder> {
  bool _isHover = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback(() {
      widget.scrollController.addListener(_updateThumbPosition);
    });
    _thumbPosition = 0;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateThumbPosition);
    super.dispose();
  }

  void _updateThumbPosition() {
    setState(() {
      _thumbPosition = widget.scrollController.offset /
          widget.scrollController.position.maxScrollExtent *
          (_widthLayout - widget.thumbHeight);
    });
  }

  late double _thumbPosition;
  late double _widthLayout;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child,
      if (widget.scrollDirection == Axis.vertical)
        PositionedDirectional(
            top: 0,
            bottom: 0,
            start: widget.onStart ? 0 : null,
            end: !widget.onStart ? 0 : null,
            child: _verticalThumb)
      else
        PositionedDirectional(
            top: widget.onStart ? 0 : null,
            bottom: !widget.onStart ? 0 : null,
            start: 0,
            end: 0,
            child: _horizontalThumb)
    ]);
  }

  Widget get _verticalThumb => Container(
        margin: widget.margin,
        decoration: widget.thumbBackgroundDecoration,
        padding: widget.thumbPadding,
        child: SizedBox(
          width: widget.thumbWidth,
          child: LayoutBuilder(builder: (context, constraints) {
            _widthLayout = constraints.maxHeight;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: widget.duration,
                  curve: widget.curve,
                  top: _thumbPosition,
                  child: GestureDetector(
                      onVerticalDragStart: (_) {
                        setState(() => _isDragging = true);
                      },
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          _thumbPosition = _thumbPosition + details.delta.dy;
                          _thumbPosition = _thumbPosition.clamp(
                              0, constraints.maxHeight - widget.thumbHeight);
                        });
                        widget.scrollController.jumpTo((_thumbPosition /
                                (_widthLayout - widget.thumbHeight)) *
                            widget.scrollController.position.maxScrollExtent);
                      },
                      onVerticalDragEnd: (_) {
                        setState(() => _isDragging = false);
                      },
                      child: MouseRegion(
                        onEnter: (_) => setState(() => _isHover = true),
                        onExit: (_) => setState(() => _isHover = false),
                        child: AnimatedContainer(
                          duration: widget.duration,
                          curve: widget.curve,
                          height: widget.thumbHeight,
                          width: widget.thumbWidth,
                          decoration: _isHover || _isDragging
                              ? widget.thumbDecorationOnHover
                              : widget.thumbDecoration,
                        ),
                      )),
                )
              ],
            );
          }),
        ),
      );

  Widget get _horizontalThumb => Container(
        margin: widget.margin,
        decoration: widget.thumbBackgroundDecoration,
        padding: widget.thumbPadding,
        child: SizedBox(
          width: widget.thumbWidth,
          child: LayoutBuilder(builder: (context, constraints) {
            _widthLayout = constraints.maxWidth;
            return Stack(
              children: [
                AnimatedPositionedDirectional(
                  duration: widget.duration,
                  curve: widget.curve,
                  start: _thumbPosition,
                  child: GestureDetector(
                      onHorizontalDragStart: (_) {
                        setState(() => _isDragging = true);
                      },
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _thumbPosition = _thumbPosition + details.delta.dx;
                          _thumbPosition = _thumbPosition.clamp(
                              0, constraints.maxWidth - widget.thumbHeight);
                        });
                        widget.scrollController.jumpTo((_thumbPosition /
                                (_widthLayout - widget.thumbHeight)) *
                            widget.scrollController.position.maxScrollExtent);
                      },
                      onHorizontalDragEnd: (_) {
                        setState(() => _isDragging = false);
                      },
                      child: MouseRegion(
                          onEnter: (_) => setState(() => _isHover = true),
                          onExit: (_) => setState(() => _isHover = false),
                          child: AnimatedContainer(
                            duration: widget.duration,
                            curve: widget.curve,
                            height: widget.thumbWidth,
                            width: widget.thumbHeight,
                            decoration: _isHover || _isDragging
                                ? widget.thumbDecorationOnHover
                                : widget.thumbDecoration,
                          ))),
                )
              ],
            );
          }),
        ),
      );
}
