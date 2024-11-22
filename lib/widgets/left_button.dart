import 'package:flutter/material.dart';
import 'package:test_scav/utils/app_colors.dart';

class LeftButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;

  const LeftButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = AppColors.primary,
    this.iconColor = Colors.white,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor,
        border: Border.all(
          color: borderColor!,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
