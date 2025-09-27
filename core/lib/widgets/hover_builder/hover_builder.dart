import 'package:flutter/material.dart';

class HoveringBuilder extends StatefulWidget {
  const HoveringBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, bool isHovered) builder;

  @override
  createState() => _HoveringBuilderState();
}

class _HoveringBuilderState extends State<HoveringBuilder> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _updateHover(true),
      onExit: (event) => _updateHover(false),
      child: widget.builder(context, _isHovered),
    );
  }

  void _updateHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

}