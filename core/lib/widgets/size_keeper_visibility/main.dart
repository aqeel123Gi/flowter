import 'package:flutter/material.dart';

class SizeKeeperVisibility extends StatefulWidget {
  @override
  createState() => _SizeKeeperVisibilityState();
  final bool visible;
  final Widget child;
  const SizeKeeperVisibility({
    super.key,
    required this.visible, required this.child
  });
}

class _SizeKeeperVisibilityState extends State<SizeKeeperVisibility> {

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        const SizedBox(),
        widget.child
      ]);
  }
}