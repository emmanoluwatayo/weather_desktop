import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/core/constants/router.dart';
import 'package:weather_desktop/core/network/api_response.dart';
import 'package:weather_desktop/data/providers/auth/forgot_password.dart';
import 'package:weather_desktop/gen/assets.gen.dart';
import 'package:weather_desktop/presentation/utilities/app_textfield.dart';
import 'package:weather_desktop/presentation/utilities/auth_button.dart';
import 'package:weather_desktop/presentation/utilities/utils.dart';
import 'package:weather_desktop/utilities/loading.dart';
import 'package:weather_desktop/utilities/toast_info.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> handleForgetPassword() async {
    if (!formKey.currentState!.validate()) {
      toastInfo(msg: "Please fill all required fields", status: Status.error);
      return;
    }

    final notifier = ref.read(forgotPasswordNotifierProvider.notifier);
    await notifier.forgetPassword(email: emailController.text.trim());

    Utils.logger.i(
      "Forget Password user with email: ${emailController.text.trim()}",
    );
    Utils.logger.d('$notifier');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ForgotPasswordState>(forgotPasswordNotifierProvider, (
      previous,
      next,
    ) {
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

        context.go(AppRouter.login);
      }
    });
    final forgotPasswordState = ref.watch(forgotPasswordNotifierProvider);
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
                            'Forget Password',
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
                          const Gap(20),
                          Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: AuthButton(
                                color: AppColors.primaryColor,
                                text:
                                    forgotPasswordState.processingStatus ==
                                            ProcessingStatus.waiting
                                        ? "Completing..."
                                        : "Complete Registration",
                                onPressed:
                                    forgotPasswordState.processingStatus ==
                                            ProcessingStatus.waiting
                                        ? null
                                        : () {
                                          handleForgetPassword(); // wrapped in void Function()
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
