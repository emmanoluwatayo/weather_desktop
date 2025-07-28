import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';

class AuthButton extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final VoidCallback? onPressed;
  const AuthButton({
    super.key,
    required this.color,
    required this.text,
    required this.onPressed,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: AppFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class AuthButton2 extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const AuthButton2({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 24,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primaryColor, width: 1.0),
            ),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: AppFonts.poppins(
                  color: AppColors.backgroundLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(4),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.backgroundLight,
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
