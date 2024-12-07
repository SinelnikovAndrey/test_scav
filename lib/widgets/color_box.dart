import 'package:flutter/material.dart';

class ColorBox extends StatelessWidget {
  final Color? color;

  const ColorBox({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: color ?? Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
