import 'package:flutter/material.dart';

// Make this class mutable
class AppText extends StatelessWidget {
  final double size;
  final String text;
  final Color? color;
  AppText({
    Key? key,
    this.size = 16,
    required this.text,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
      ),
    );
  }
}
