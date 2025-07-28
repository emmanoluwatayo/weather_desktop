// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/core/constants/router.dart';
import 'package:weather_desktop/core/network/api_response.dart';
import 'package:weather_desktop/data/providers/auth/signup_notifier.dart';
import 'package:weather_desktop/gen/assets.gen.dart';
import 'package:weather_desktop/utilities/loading.dart';
import 'package:weather_desktop/presentation/utilities/app_textfield.dart';
import 'package:weather_desktop/presentation/utilities/auth_button.dart';
import 'package:weather_desktop/presentation/utilities/utils.dart';
import 'package:weather_desktop/utilities/toast_info.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isObscured = true;
  bool isObscured2 = true;

  void toggleObscure() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  void toggleObscure2() {
    setState(() {
      isObscured2 = !isObscured2;
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> handleRegister() async {
    if (!formKey.currentState!.validate()) {
      toastInfo(msg: "Please fill all required fields", status: Status.error);
      return;
    }

    final notifier = ref.read(signUpNotifierProvider.notifier);

    Utils.logger.i(
      "Registering user with email: ${emailController.text.trim()}",
    );
    Utils.logger.i("Full Name: ${fullNameController.text.trim()}");
    Utils.logger.d('$notifier');

    await notifier.registerWithEmailAndPassword(
      fullName: fullNameController.text.trim(),
      emailAddress: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SignUpState>(signUpNotifierProvider, (previous, next) {
      if (next.processingStatus == ProcessingStatus.waiting) {
        context.showLoader();
      } else {
        context.hideLoader();
      }

      if (next.processingStatus == ProcessingStatus.error) {
        toastInfo(msg: 'Oops! ${next.error.errorMsg}', status: Status.error);
      }

      if (next.processingStatus == ProcessingStatus.success) {
        toastInfo(
          msg: 'Success! Account created. Check your email for verification.',
          status: Status.completed,
        );
        context.go(AppRouter.completeRegistration);
      }
    });

    final signUpState = ref.watch(signUpNotifierProvider);

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
                  width: 420,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary,
                    backgroundBlendMode: BlendMode.modulate,
                    border: Border.all(color: AppColors.textPrimary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: formKey,
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
                        AppTextField(
                          label: 'Full Name',
                          controller: fullNameController,
                          title: 'Full Name',
                          obscureText: false,
                          keyboardType: TextInputType.text,
                        ),
                        const Gap(10),
                        AppTextField(
                          label: 'Email Address',
                          controller: emailController,
                          title: 'Email',
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const Gap(10),
                        AuthPasswordTextField(
                          hintText: 'Choose a strong password',
                          controller: passwordController,
                          isObscured: isObscured,
                          toggleObscure: toggleObscure,
                          title: 'Password',
                        ),

                        const Gap(10),
                        AuthPasswordTextField(
                          hintText: 'Confirm Password',
                          controller: passwordController2,
                          passwordController: passwordController,
                          isConfirmPassword: true,
                          isObscured: isObscured2,
                          toggleObscure: toggleObscure2,
                          title: 'Confirm Password',
                        ),

                        const Gap(20),
                        Align(
                          alignment: Alignment.center,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: AuthButton(
                              color: AppColors.primaryColor,
                              text:
                                  signUpState.processingStatus ==
                                          ProcessingStatus.waiting
                                      ? "Registering..."
                                      : "Register",
                              onPressed:
                                  signUpState.processingStatus ==
                                          ProcessingStatus.waiting
                                      ? null
                                      : () {
                                        handleRegister(); // wrapped in void Function()
                                      },
                              textColor: AppColors.backgroundCard,
                            ),
                          ),
                        ),
                        const Gap(20),
                        Align(
                          alignment: Alignment.center,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: SizedBox(
                              width: 250,
                              child: AuthButton2(
                                title: 'Got an account? Log in instead',
                                onTap: () {
                                  context.go(AppRouter.login);
                                },
                              ),
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
        ],
      ),
    );
  }
}
