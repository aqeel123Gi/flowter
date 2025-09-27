library abc;

import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';
import 'package:flowter_core/widgets/ignoring_updateing_state/ignoring_updating_state.dart';
part 'controller.dart';

class AnimatedWidgetSwitcher<T> extends StatefulWidget {
  const AnimatedWidgetSwitcher(
      {super.key,
      this.showAfter = Duration.zero,
      required this.switchingKey,
      this.showingTransform,
      this.hidingTransform,
      required this.builder});

  final Duration showAfter;
  final T switchingKey;
  final TransformData? showingTransform;
  final TransformData? hidingTransform;
  final Widget Function(T switchingKey) builder;

  @override
  State<AnimatedWidgetSwitcher<T>> createState() =>
      _AnimatedWidgetSwitcherState<T>();
}

class _AnimatedWidgetSwitcherState<T> extends State<AnimatedWidgetSwitcher<T>> {
  final _AnimatedWidgetSwitcherController<T> _controller =
      _AnimatedWidgetSwitcherController<T>();

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<_AnimatedWidgetSwitcherController>(
        widget: widget,
        controller: _controller,
        builder: (context, c) {
          _controller.appendOnSwitchingKeyChanged();

          return Stack(children: _controller.data.build((i, e) {
            if (e == null) {
              return const SizedBox();
            }

            return Animate(
              key: e.globalKey,
              show: true,
              showAfter: widget.showAfter,
              controller: e.animateController,
              startFrom: widget.showingTransform ??
                  TransformData(
                      opacity: 0, duration: const Duration(milliseconds: 500)),
              endTo: widget.hidingTransform ??
                  TransformData(
                      opacity: 0, duration: const Duration(milliseconds: 500)),
              child: IgnoringUpdatingState(
                  ignoring: i + 1 != _controller.data.length,
                  child: e.builder(e.switchingKey)),
            );
          }));
        });
  }
}
