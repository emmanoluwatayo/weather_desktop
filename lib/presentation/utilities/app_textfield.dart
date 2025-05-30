import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String title;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.title,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        Gap(10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: AppColors.softLightGrey,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: AppFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w100,
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
