import 'package:flowter_core/extensions/extensions.dart';
import 'package:flowter_core/widgets/widget_controller/widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';
import 'controller.dart';

class ColRow extends StatefulWidget {
  const ColRow({
    super.key,
    required this.widthSeparation,
    this.onColumnCrossAxisAlignment = CrossAxisAlignment.center,
    this.onRowCrossAxisAlignment = CrossAxisAlignment.center,
    this.onColumnBuilder,
    this.onRowBuilder,
    required this.children,
  });

  final double widthSeparation;
  final CrossAxisAlignment onColumnCrossAxisAlignment;
  final CrossAxisAlignment onRowCrossAxisAlignment;
  final Widget Function(BuildContext context, Widget child)? onColumnBuilder;
  final Widget Function(BuildContext context, Widget child)? onRowBuilder;
  final List<Widget> children;

  @override
  State<ColRow> createState() => _ColRowState();
}

class _ColRowState extends State<ColRow> {
  final CoRoController _controller = CoRoController();

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<CoRoController>(
        widget: widget,
        controller: _controller,
        builder: (context, c) {
          return LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < widget.widthSeparation) {
              return Column(
                crossAxisAlignment: widget.onColumnCrossAxisAlignment,
                children: widget.onColumnBuilder == null
                    ? widget.children
                    : widget.children
                        .build((_, e) => widget.onColumnBuilder!(context, e)),
              );
            } else {
              return Row(
                crossAxisAlignment: widget.onRowCrossAxisAlignment,
                children: widget.onRowBuilder == null
                    ? widget.children
                    : widget.children
                        .build((_, e) => widget.onRowBuilder!(context, e)),
              );
            }
          });
        });
  }
}
