import 'package:flutter/material.dart';

// Make this class mutable
class AppText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color? color;
  AppText({
    Key? key,
    required this.text,
    this.size = 16,
    this.weight = FontWeight.normal,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: weight,
      ),
    );
  }
}
