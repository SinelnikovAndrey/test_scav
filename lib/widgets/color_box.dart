import 'package:flutter/material.dart';

class ColorBox extends StatelessWidget {
  final Color? color;
  final double height;
  final double width;

  const ColorBox({super.key, required this.color, required this.height, required this.width, });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
