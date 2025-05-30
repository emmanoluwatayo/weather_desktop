import 'package:flutter/material.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';

class AuthButton extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final VoidCallback onPressed;
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
