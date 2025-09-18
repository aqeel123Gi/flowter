import 'dart:math';
import 'package:flutter/cupertino.dart';
import '../blur/blur.dart';
import '../../classes/on_changing_value.dart';
import '../widget_controller/widget_controller.dart';
import '../child_size_detector/child_size_detector.dart';
import 'controller.dart';


class DraggableBottomSheet extends StatefulWidget {
  @override
  createState() => _DraggableBottomSheetState();
  const DraggableBottomSheet({
    super.key,

    this.onClosed,
    required this.decoration,
    required this.duration,
    required this.curve,
    this.maxWidth,
    this.maxHeight,
    this.shrinkHeight,
    this.draggable = true,
    this.blur = false,
    required this.foregroundBuilder,
    this.backgroundBuilder,
    this.sheetHorizontalMargin = 0,
    this.maxSheetWidth = double.infinity,
    this.onDraggingStateChanged
  });


  final Widget Function(BuildContext context, ScrollController scrollController, double maxToHalfRatio, double currentHeight) foregroundBuilder;
  final Widget Function(BuildContext context, double maxToHalfRatio, double currentHeight)? backgroundBuilder;
  final void Function()? onClosed;
  final double sheetHorizontalMargin;
  final double maxSheetWidth;
  final BoxDecoration decoration;
  final Duration duration;
  final Curve curve;

  final double? maxWidth;
  final double Function(double maxLayoutHeight)? maxHeight;
  final double Function(double maxLayoutHeight)? shrinkHeight;

  final bool draggable;
  final bool blur;

  final void Function(bool onDragging)? onDraggingStateChanged;
}


class _DraggableBottomSheetState extends State<DraggableBottomSheet> {

  final DraggableBottomSheetController _controller = DraggableBottomSheetController();

  final OnChangingValue<double> _onChanged = OnChangingValue<double>(0);

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<DraggableBottomSheetController>(
        widget: widget,
        controller: _controller,
        builder: (context, c) {

          return LayoutBuilder(
                          builder: (context, constraints) {

                            _controller.maxLayoutHeight = constraints.maxHeight;
                            _controller.maxHeight = widget.maxHeight == null ? constraints.maxHeight : widget.maxHeight!(constraints.maxHeight);

                            _onChanged.setOn(
                                condition: ()=>_controller.completedPostInit,
                                value: constraints.maxHeight,
                                onChanged: () {
                              if (_controller.expanded) {
                                _controller.currentHeight = widget.maxHeight != null ? widget.maxHeight!(
                                    _controller.maxLayoutHeight) : _controller
                                    .maxLayoutHeight;
                              } else {
                                _controller.currentHeight = _controller.shrinkHeight(_controller.maxLayoutHeight);
                              }
                            });

                            double maxToHalfRatio = min(1,max(0,(_controller.maxHeight - _controller.currentHeight)/(_controller.maxHeight - _controller.shrinkHeight(_controller.maxLayoutHeight))));


                            return Stack(
                                children: [

                              if (widget.backgroundBuilder != null)
                                 widget.backgroundBuilder!(context, maxToHalfRatio, _controller.currentHeight),

                              Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: widget.sheetHorizontalMargin,
                                  right: widget.sheetHorizontalMargin,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: widget.maxSheetWidth),
                                      child: Listener(
                                          onPointerDown: widget.draggable
                                              ? _controller.verticalDragStart
                                              : null,
                                          onPointerMove: widget.draggable
                                              ? _controller.verticalDragUpdate
                                              : null,
                                          onPointerUp: widget.draggable
                                              ? _controller.verticalDragEnd
                                              : null,
                                          child: Blur(
                                              active: widget.blur,
                                              strength: 25,
                                              child: SingleChildScrollView(
                                                physics: const NeverScrollableScrollPhysics(),
                                                child: AnimatedContainer(
                                                  curve: widget.curve,
                                                  duration: _controller.duration,
                                                  height: _controller.currentHeight,
                                                  clipBehavior: Clip.antiAlias,
                                                  padding: EdgeInsets.zero,
                                                  decoration: widget.decoration,
                                                  child: Builder(
                                                    builder: (context) {


                                                      if(widget.shrinkHeight!=null){
                                                        return widget.foregroundBuilder(context,_controller.scrollController,maxToHalfRatio, _controller.currentHeight);
                                                      }

                                                      return ChildSizeDetector(
                                                          onChange: (size){

                                                            _controller.contentHeight = size.height;
                                                            if(!_controller.expanded){
                                                              _controller.currentHeight = size.height;
                                                            }
                                                            _controller.updateState();

                                                          },
                                                          child: ConstrainedBox(
                                                            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                                                            child: widget.foregroundBuilder(context,_controller.scrollController,maxToHalfRatio, _controller.currentHeight)
                                                          )
                                                      );
                                                    }
                                                  ),
                                              ))),
                                    )),
                                  ))
                            ]);
                          },
                        );
              }
            );
        }


}


