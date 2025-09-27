library direct_future_builder;

import 'package:flutter/material.dart';
import 'package:flowter_core/flowter_core.dart';
part 'controller.dart';

enum DirectFutureState { loading, success, error }

class DirectFutureBuilderController {
  DirectFutureBuilderWidgetController? _widgetController;
  void Function() get repeat => _widgetController!.repeat;
  DirectFutureState get state => _widgetController!.directFutureState;
  bool get initialized => _widgetController!.init;
}

class DirectFutureBuilder<T> extends StatefulWidget {
  const DirectFutureBuilder(
      {super.key,
      required this.controller,
      required this.directFuture,
      required this.future,
      required this.builder});

  final DirectFutureBuilderController? controller;
  final Future<T> Function() directFuture;
  final Future<T> Function() future;
  final Widget Function(BuildContext context, DirectFutureState state, T data)
      builder;

  @override
  State<DirectFutureBuilder<T>> createState() => _DirectFutureBuilderState<T>();
}

class _DirectFutureBuilderState<T> extends State<DirectFutureBuilder<T>> {
  final DirectFutureBuilderWidgetController<T> _controller =
      DirectFutureBuilderWidgetController<T>();

  @override
  Widget build(BuildContext context) {
    return WidgetControllerBuilder<DirectFutureBuilderWidgetController>(
        widget: widget,
        controller: _controller,
        builder: (context, c) => _controller.init
            ? widget.builder(
                context, _controller.directFutureState, _controller.data as T)
            : const SizedBox());
  }
}
