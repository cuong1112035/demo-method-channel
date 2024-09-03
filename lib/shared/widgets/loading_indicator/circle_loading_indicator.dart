import 'package:flutter/material.dart';

class CircleLoadingIndicator extends StatelessWidget {
  final Color color;

  const CircleLoadingIndicator.blue({
    super.key,
  }) : color = Colors.blue;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: 4,
      ),
    );
  }
}