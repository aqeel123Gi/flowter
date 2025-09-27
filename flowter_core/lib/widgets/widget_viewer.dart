import 'dart:math';
import 'package:flowter_core/flowter_core.dart';
import 'package:flutter/material.dart';

void viewWidget(GlobalKey widgetKey, Widget widget) {
  TemplateController.push(TemplateData(
    id: "WIDGET_VIEWER",
    body: WidgetViewer(
        initEdgesCoordinates: getEdgesFromKey(widgetKey)!, widget: widget),
    bottomPadding_: false,
    topPadding_: false,
    backgroundType: BackgroundType.blurred,
  ));
}

class WidgetViewer extends StatefulWidget {
  const WidgetViewer({
    super.key,
    required this.initEdgesCoordinates,
    required this.widget,
  });

  final EdgesCoordinates initEdgesCoordinates;
  final Widget widget;

  @override
  State<WidgetViewer> createState() => _WidgetViewerState();
}

class _WidgetViewerState extends State<WidgetViewer> {
  late Size _size;
  late Offset _offset;
  double _rotation = 0;
  double _scale = 1;
  bool _show = false;

  bool _hide() {
    setState(() {
      _offset = Offset(
          widget.initEdgesCoordinates.left, widget.initEdgesCoordinates.top);
      _rotation = 0;
      _scale = 1;
      _show = false;
    });
    return true;
  }

  double scale() {
    Size screen = MediaQuery.of(context).size;

    double xScale = screen.width - _size.height;
    double yScale = screen.height - _size.width;

    if (xScale < yScale) {
      return screen.width / _size.height * 0.8;
    } else {
      return screen.height / _size.width * 0.8;
    }
  }

  @override
  void initState() {
    _size = widget.initEdgesCoordinates.getSize();
    _offset = Offset(
        widget.initEdgesCoordinates.left, widget.initEdgesCoordinates.top);
    addPostFrameCallback(() {
      setState(() {
        _rotation = pi / 2;
        _show = true;
        _scale = scale();
        _offset = Offset((MediaQuery.of(context).size.width - _size.width) / 2,
            (MediaQuery.of(context).size.height - _size.height) / 2);
      });
    });
    TemplateData.ofBodyState(this)!.onBackButtonPressed = _hide;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _show ? 1 : 0,
            child: Stack(children: [
              Positioned(
                  left: 0,
                  top: 0,
                  child: AnimatedTransform(
                      data: TransformData(
                          curve: Curves.easeOutCirc,
                          duration: const Duration(milliseconds: 1000),
                          x: _offset.dx,
                          y: _offset.dy,
                          scale: _scale,
                          rotation: _rotation,
                          opacity: 1),
                      child: widget.widget)),
            ])));
  }
}
