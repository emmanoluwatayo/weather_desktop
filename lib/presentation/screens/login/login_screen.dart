import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/core/constants/router.dart';
import 'package:weather_desktop/core/network/api_response.dart';
import 'package:weather_desktop/data/providers/auth/signin_notifier.dart';
import 'package:weather_desktop/gen/assets.gen.dart';
import 'package:weather_desktop/presentation/utilities/app_textfield.dart';
import 'package:weather_desktop/presentation/utilities/auth_button.dart';
import 'package:weather_desktop/presentation/utilities/utils.dart';
import 'package:weather_desktop/utilities/loading.dart';
import 'package:weather_desktop/utilities/toast_info.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isObscured = true;

  void toggleObscure() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> handleSignIn() async {
    if (!formKey.currentState!.validate()) {
      toastInfo(msg: "Please fill all required fields", status: Status.error);
      return;
    }

    final notifier = ref.read(signInNotifierProvider.notifier);

    Utils.logger.i(
      "Signing in user with email: ${emailController.text.trim()}",
    );
    Utils.logger.d('$notifier');

    await notifier.signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SignInState>(signInNotifierProvider, (previous, next) {
      if (next.processingStatus == ProcessingStatus.waiting) {
        context.showLoader();
      } else {
        context.hideLoader();
      }

      if (next.processingStatus == ProcessingStatus.error) {
        toastInfo(msg: 'Oops! ${next.error.errorMsg}', status: Status.error);
      }

      if (next.processingStatus == ProcessingStatus.success) {
        // toastInfo(
        //   msg: 'Success! Account creation completed. You can now log in.',
        //   status: Status.completed,
        // );

        context.go(AppRouter.navigationPage);
      }
    });
    final signInState = ref.watch(signInNotifierProvider);
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
                  // ignore: deprecated_member_use
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
                padding: const EdgeInsets.only(top: 30, bottom: 20),
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
                            'Login',
                            style: AppFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          const Gap(20),
                          AppTextField(
                            label: 'Email Address',
                            controller: emailController,
                            title: 'Email',
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(10),

                          AuthPasswordTextField(
                            hintText: 'Enter password',
                            controller: passwordController,
                            isObscured: isObscured,
                            toggleObscure: toggleObscure,
                            title: 'Password',
                          ),
                          const Gap(20),
                          Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: AuthButton(
                                color: AppColors.primaryColor,
                                text:
                                    signInState.processingStatus ==
                                            ProcessingStatus.waiting
                                        ? "Signing in..."
                                        : "Sign In",
                                onPressed:
                                    signInState.processingStatus ==
                                            ProcessingStatus.waiting
                                        ? null
                                        : () {
                                          handleSignIn(); // wrapped in void Function()
                                        },
                                textColor: AppColors.backgroundCard,
                              ),
                            ),
                          ),
                          const Gap(48),
                          Row(
                            children: [
                              AuthButton2(
                                title: 'Forgot Password?',
                                onTap: () {
                                    context.go(AppRouter.forgotPassword);
                                },
                              ),
                              const Spacer(),
                              AuthButton2(
                                title: 'Create New Account',
                                onTap: () {
                                  context.go(AppRouter.register);
                                },
                              ),
                            ],
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
