// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/core/constants/router.dart';
import 'package:weather_desktop/gen/assets.gen.dart';
import 'package:weather_desktop/presentation/utilities/app_textfield.dart';
import 'package:weather_desktop/presentation/utilities/auth_button.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController middleNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController countryController = TextEditingController();
    final TextEditingController stateController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController confirmpasswordController =
        TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.backgroundCard,
      body: Stack(
        children: [
          // Background Image
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.images.cloud3.path),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Foreground Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                child: Container(
                  width: 420, // Fixed width of the card
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary,
                    backgroundBlendMode: BlendMode.modulate,
                    border: Border.all(color: AppColors.textPrimary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registration',
                            style: AppFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          const Gap(20),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'First Name',
                                  controller: firstNameController,
                                  title: 'First Name',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: AppTextField(
                                  label: 'Middle Name',
                                  controller: middleNameController,
                                  title: 'Middle Name',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: AppTextField(
                                  label: 'Last Name',
                                  controller: lastNameController,
                                  title: 'Last Name',
                                  obscureText: false,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          AppTextField(
                            label: 'Email Address',
                            controller: emailController,
                            title: 'Email',
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(10),
                          AppTextField(
                            label: 'Country name',
                            controller: countryController,
                            title: 'Country',
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(10),
                          AppTextField(
                            label: 'State',
                            controller: stateController,
                            title: 'State',
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(10),
                          AppTextField(
                            label: 'City',
                            controller: cityController,
                            title: 'City',
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(10),
                          AppTextField(
                            label: 'Address in full details',
                            controller: addressController,
                            title: 'Address',
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(10),
                          AppTextField(
                            label: 'Password',
                            controller: passwordController,
                            title: 'Password',
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(10),
                          AppTextField(
                            label: 'Confirm Password',
                            controller: confirmpasswordController,
                            title: 'Confirm Password',
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(20),
                          Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: AuthButton(
                                color: AppColors.primaryColor,
                                text: 'Register',
                                onPressed: () {
                                  context.go(AppRouter.login);
                                },
                                textColor: AppColors.backgroundCard,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
