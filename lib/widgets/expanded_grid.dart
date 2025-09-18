import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class ExpandedGrid extends StatelessWidget {
  const ExpandedGrid({
    super.key,
    required this.children
  });

  final List<List<Widget>> children;

  @override
  Widget build(BuildContext context) {
    return Column(children: children.map((e) => Row(children: e.expandedBuild())).toList().expandedBuild());
  }
}