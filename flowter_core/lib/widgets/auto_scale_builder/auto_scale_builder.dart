library auto_scale_builder;

import 'dart:math';

import 'package:flowter_core/widgets/widget_controller/widget_controller.dart';
import 'package:flutter/material.dart';
part '_controller.dart';

class AutoScaleBuilder extends StatefulWidget {
  const AutoScaleBuilder(
      {super.key,
      required this.contentSize,
      this.maxScale = double.infinity,
      this.maxHeightConstraint = double.infinity,
      this.maxWidthConstraint = double.infinity,
      this.alignment = Alignment.center,
      required this.builder});

  final Size contentSize;
  final double maxScale;
  final double maxHeightConstraint;
  final double maxWidthConstraint;
  final Alignment alignment;
  final Widget Function(BuildContext context, double scale) builder;

  @override
  State<AutoScaleBuilder> createState() => _AutoScaleBuilderState();
}

class _AutoScaleBuilderState extends State<AutoScaleBuilder> {
  final AutoScaleBuilderController _controller = AutoScaleBuilderController();

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<AutoScaleBuilderController>(
        widget: widget,
        controller: _controller,
        builder: (context, c) {
          return LayoutBuilder(builder: (context, constraints) {
            _controller.shouldBeFiniteLayoutBox(constraints);
            return _builder(context, constraints);
          });
        });
  }

  Widget _builder(BuildContext context, BoxConstraints layoutConstraints) {
    double heightConstraint =
        min(layoutConstraints.maxHeight, widget.maxHeightConstraint);
    double widthConstraint =
        min(layoutConstraints.maxWidth, widget.maxWidthConstraint);

    double scale =
        _controller.maxScaleCalculation(heightConstraint, widthConstraint);

    return SizedBox(
      height: layoutHeight(layoutConstraints, scale),
      width: layoutWidth(layoutConstraints, scale),
      child: Stack(
        children: [
          Positioned(
            top: layoutHeight(layoutConstraints, scale) /
                    (1 / _changeRange(widget.alignment.y)) -
                (_changeRange(widget.alignment.y) * widget.contentSize.height),
            left: layoutWidth(layoutConstraints, scale) /
                    (1 / _changeRange(widget.alignment.x)) -
                (_changeRange(widget.alignment.x) * widget.contentSize.width),
            height: widget.contentSize.height,
            width: widget.contentSize.width,
            child: Container(
                transformAlignment: widget.alignment,
                transform: Matrix4.identity().scaled(scale),
                alignment: widget.alignment,
                child: widget.builder(context, scale)),
          ),
        ],
      ),
    );
  }

  double _changeRange(double alignment) {
    return (alignment + 1) / 2;
  }

  double layoutHeight(BoxConstraints layoutConstraints, double scale) {
    return _controller.finiteHeightLayoutBox(layoutConstraints)
        ? layoutConstraints.maxHeight
        : scale * widget.contentSize.height;
  }

  double layoutWidth(BoxConstraints layoutConstraints, double scale) {
    return _controller.finiteWidthLayoutBox(layoutConstraints)
        ? layoutConstraints.maxWidth
        : scale * widget.contentSize.width;
  }
}
