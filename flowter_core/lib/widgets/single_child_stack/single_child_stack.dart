import 'package:flutter/material.dart';

class SingleChildStack extends StatelessWidget {
  const SingleChildStack({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child
      ],
    );
  }
}
