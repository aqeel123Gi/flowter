import 'package:flutter/material.dart';

class IgnoringUpdatingState extends StatefulWidget {
  final Widget child;
  final bool ignoring;

  const IgnoringUpdatingState({
    super.key,
    required this.child,
    this.ignoring = true,
  });

  @override
  State<IgnoringUpdatingState> createState() => _IgnoringUpdatingStateState();
}

class _IgnoringUpdatingStateState extends State<IgnoringUpdatingState> {

  late Widget _lastState;

  @override
  void initState() {
    _lastState = widget.child;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.ignoring){
      return _lastState;
    }

    _lastState = widget.child;
    return widget.child;
  }

}
