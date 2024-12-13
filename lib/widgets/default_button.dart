import 'package:flutter/material.dart';
import 'package:test_scav/utils/app_colors.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final bool isEnabled;

  const DefaultButton({
    super.key,
    required this.text,
    required this.onTap,
    this.leading,
    this.trailing,
    this.backgroundColor = AppColors.primary,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: isEnabled ? onTap : null,
        child: Container(
          height: 60,
              width: 382,
              decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.primary 
              : Colors.white.withOpacity(0.5), 
          borderRadius: BorderRadius.circular(100),

        ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leading != null) leading!,
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
