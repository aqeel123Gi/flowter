library news_ticker;

import 'package:flowter_core/widgets/widget_controller/widget_controller.dart';
import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';

part 'controller.dart';

class NewsTicker extends StatefulWidget {

  final double tickerHeight;
  final List<Widget> children;
  final double Function(double tickerWidth) velocity;

  const NewsTicker({
    super.key,
    required this.tickerHeight,
    required this.velocity,
    required this.children,

  });

  @override
  State<NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends State<NewsTicker> with SingleTickerProviderStateMixin {


  final _NewsTickerController _controller = _NewsTickerController();


  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<_NewsTickerController>(
        widget: widget,
        state: this,
        controller: _controller,
        builder: (context, c) {
          return LayoutBuilder(
            builder: (context,constraints) {
              {

                _controller.tickerWidth = constraints.maxWidth;

                return ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: widget.tickerHeight,
                      minHeight: widget.tickerHeight
                  ),
                  child: ListView.builder(
                    controller: _controller.scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.children.length * 100,
                    itemBuilder: (context, index) {
                      return Center(child: widget.children[index %
                          widget.children.length]);
                    },
                  ),
                );
              }
            }
          );
        }
    );
  }
}














