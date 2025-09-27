import 'package:flutter/material.dart';
import 'package:flowter/flowter.dart';

class FlexGrid extends StatelessWidget {
  const FlexGrid({super.key, required this.flexes, required this.children});

  final List<List<int>> flexes;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (flexes.concatenated<int>().length != children.length) {
      throw Exception("The length of flexes and children must be the same");
    }

    List<Row> rows = [];

    for (int i = 0; i < flexes.length; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < flexes[i].length; j++) {
        rowChildren.add(Expanded(
          flex: flexes[i][j],
          child: children[i * flexes[i].length + j],
        ));
      }
      rows.add(Row(children: rowChildren));
    }

    return Column(children: rows);
  }
}
