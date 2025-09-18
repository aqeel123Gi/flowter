import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MouseDraggableScrollWrapper extends StatelessWidget {
  final ScrollController scrollController;
  final Axis scrollDirection;
  final Widget child;

  const MouseDraggableScrollWrapper({
    super.key,
    required this.scrollController,
    this.scrollDirection = Axis.vertical,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {


    if(child is! ScrollView) {
      throw Exception('child must be Scrollable');
    }


    TextDirection textDirection = Directionality.of(context);


    return Stack(
      children: [
        child,
        Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              final isHorizontal = scrollDirection == Axis.horizontal;
              final delta = isHorizontal ? event.scrollDelta.dx : event.scrollDelta.dy;

              scrollController.jumpTo(
                scrollController.offset + delta,
              );
            }
          },
          child: GestureDetector(
            onPanUpdate: (details) {
              final isHorizontal = scrollDirection == Axis.horizontal;
              final delta = isHorizontal ? (textDirection == TextDirection.ltr ? -details.delta.dx: details.delta.dx) : -details.delta.dy;

              scrollController.jumpTo(
                scrollController.offset + delta,
              );
            },
            child: const AbsorbPointer(
              absorbing: true,
              child: SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }
}
