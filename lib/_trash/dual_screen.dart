import 'package:flutter/material.dart';

class DualScreen extends StatefulWidget {
  const DualScreen({
    super.key,
    required this.originalScreen,
    required this.secondaryScreen
  });

  final Widget originalScreen;
  final Widget secondaryScreen;

  @override
  State<DualScreen> createState() => _DualScreenState();
}

class _DualScreenState extends State<DualScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.originalScreen;
  }
}