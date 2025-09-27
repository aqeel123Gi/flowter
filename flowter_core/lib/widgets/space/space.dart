import 'package:flutter/cupertino.dart';

class Space extends StatelessWidget {
  const Space(this.amount,{super.key});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: amount,
      width: amount
    );
  }
}
