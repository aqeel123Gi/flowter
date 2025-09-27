/// A solution for efficient state management in Flutter that allows
/// selective updates of specific parts of the widget tree.
///
///
/// ## Features:
/// 1. **Selective Updates**: Allows widgets to rebuild only when associated
///    `PartialStatePoint`s are triggered, avoiding unnecessary rebuilds.
/// 2. **Performance Optimization**: Reduces the overhead of full widget
///    tree rebuilds, making it suitable for complex UI structures.
/// 3. **Flexible State Management**: Supports multiple `PartialStatePoint`s,
///    enabling granular control over state changes in different parts of the UI.
/// 4. **Ease of Integration**: Simple API with intuitive `trigger()`
///    and `builder` mechanisms for defining and responding to state changes.
///
/// This library includes:
/// - [PartialStatePoint]: A class for managing individual state points.
/// - [PartialStateBuilder]: A widget for efficient UI updates.
///
///
library partial_state_builder;

import 'package:flutter/material.dart';



/// A class that acts as a trigger point for selective UI updates.
/// It manages a counter and a list of callback functions to notify
/// subscribed widgets about state changes.
class PartialStatePoint {
  /// Internal counter to track updates.
  @protected
  num _counter = 0;

  /// A set of callbacks to be called whenever the state changes.
  @protected
  final Set<VoidCallback> _statesUpdate = {};

  /// Increments the counter and triggers all subscribed callbacks.
  void trigger() {
    _counter++;
    for (var fun in _statesUpdate) {
      fun();
    }
  }

  @override
  String toString() {
    return "PartialStatePoint($_counter)";
  }
}

/// A StatefulWidget that rebuilds its subtree based on changes
/// in one or more `PartialStatePoint` instances.
class PartialStateBuilder extends StatefulWidget {
  const PartialStateBuilder({
    super.key,
    required this.points,
    required this.builder,
  });

  /// A list of `PartialStatePoint`s that this widget listens to.
  final List<PartialStatePoint> points;

  /// A builder function that generates the widget tree.
  final Widget Function(BuildContext context) builder;

  @override
  State<PartialStateBuilder> createState() => _PartialStateBuilderState();
}


class _PartialStateBuilderState extends State<PartialStateBuilder> {
  /// The current widget built by the builder function.
  late Widget _currentWidget;

  /// Tracks the last known counter values of the `PartialStatePoint`s.
  late List<num> _lastCounters;

  /// Updates the state when a `PartialStatePoint` triggers.
  void _updateState() {
    setState(() {});
  }

  @override
  void initState() {
    // Initialize the current widget and counter values.
    _currentWidget = widget.builder(context);
    _lastCounters = widget.points.map((e) => e._counter).toList();

    // Subscribe to each provided `PartialStatePoint`.
    for (var point in widget.points) {
      point._statesUpdate.add(_updateState);
    }
    super.initState();
  }

  @override
  void dispose() {
    // Unsubscribe from all `PartialStatePoint`s to avoid memory leaks.
    for (var point in widget.points) {
      point._statesUpdate.remove(_updateState);
    }
    super.dispose();
  }

  /// Checks if any of the subscribed `PartialStatePoint`s have changed.
  /// If so, rebuilds the widget tree.
  void _checkUpdates() {
    bool changed = false;

    // Compare the current counters with the last known counters.
    for (int i = 0; i < _lastCounters.length; i++) {
      if (_lastCounters[i] != widget.points[i]._counter) {
        _lastCounters[i] = widget.points[i]._counter;
        changed = true;
      }
    }

    // If changes are detected, rebuild the current widget.
    if (changed) {
      _currentWidget = widget.builder(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check for updates before building the widget.
    _checkUpdates();
    return _currentWidget;
  }
}
