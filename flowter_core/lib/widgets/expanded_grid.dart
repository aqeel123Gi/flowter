import 'package:flowter_core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ExpandedGrid extends StatelessWidget {
  const ExpandedGrid({super.key, required this.children});

  final List<List<Widget>> children;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: children
            .map((e) => Row(children: e.expandedBuild()))
            .toList()
            .expandedBuild());
  }
}
