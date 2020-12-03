import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  final double size;
  final Color color;

  CircularIndicator({
    this.size = 30,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
