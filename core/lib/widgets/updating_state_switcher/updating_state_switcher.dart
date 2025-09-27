import 'package:flutter/material.dart';

class UpdatingStateSwitcher<T> extends StatefulWidget {
  const UpdatingStateSwitcher({
    super.key,
    required this.switchers,
    required this.child
  });

  final T switchers;
  final Widget child;


  @override
  State<UpdatingStateSwitcher<T>> createState() => _UpdatingStateSwitcherState<T>();
}

class _UpdatingStateSwitcherState<T> extends State<UpdatingStateSwitcher<T>> {


  @override
  void initState() {
    _currentBuiltWidget = widget.child;
    _currentSwitcher = widget.switchers;
    super.initState();
  }

  late Widget _currentBuiltWidget;
  late T _currentSwitcher;


  @override
  Widget build(BuildContext context) {

    if(_currentSwitcher!=widget.switchers){
      _currentSwitcher = widget.switchers;
      _currentBuiltWidget = widget.child;
    }

    return _currentBuiltWidget;
  }
}
