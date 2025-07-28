import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/utilities/password_validator.dart';

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



class AuthPasswordTextField extends StatefulWidget {
  const AuthPasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isAutofocused = false,
    required this.isObscured,
    required this.toggleObscure,
    this.isConfirmPassword = false,
    this.passwordController,
    this.isLoginField = false,
    required this.title,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isAutofocused;
  final bool isObscured;
  final Function toggleObscure;
  final bool isConfirmPassword;
  final TextEditingController? passwordController;
  final bool isLoginField;
  final String title;

  @override
  State<AuthPasswordTextField> createState() => _AuthPasswordTextFieldState();
}

class _AuthPasswordTextFieldState extends State<AuthPasswordTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          autofocus: widget.isAutofocused,
          obscureText: widget.isObscured,
          keyboardType: TextInputType.visiblePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (widget.isConfirmPassword) {
              if (widget.passwordController?.text != widget.controller.text) {
                return "Password mismatch!";
              }
            }

            if (widget.isLoginField) {
              if (value!.isEmpty) {
                return "Password can not be empty";
              }
            } else {
              return value!.validatePassword();
            }

            return null;
          },
          style: AppFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: AppColors.softLightGrey,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w100,
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
              ),
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => widget.toggleObscure(),
                      child: Icon(
                        widget.isObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
