import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/core/constants/router.dart';
import 'package:weather_desktop/core/network/api_response.dart';
import 'package:weather_desktop/data/providers/auth/complete_signup_notifier.dart';
import 'package:weather_desktop/gen/assets.gen.dart';
import 'package:weather_desktop/presentation/utilities/app_textfield.dart';
import 'package:weather_desktop/presentation/utilities/auth_button.dart';
import 'package:weather_desktop/presentation/utilities/utils.dart';
import 'package:weather_desktop/utilities/loading.dart';
import 'package:weather_desktop/utilities/toast_info.dart';

class CompleteRegistration extends ConsumerStatefulWidget {
  const CompleteRegistration({super.key});

  @override
  ConsumerState<CompleteRegistration> createState() =>
      _CompleteRegistrationState();
}

class _CompleteRegistrationState extends ConsumerState<CompleteRegistration> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController lgaController = TextEditingController();

  String? stateValue;

  String lgaValue = 'Choose an LGA';
  List<String> statesLga = [];

  @override
  void dispose() {
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    addressController.dispose();
    occupationController.dispose();
    phoneNumberController.dispose();
    lgaController.dispose();
    super.dispose();
  }

  Future<void> handleCompleteRegister() async {
    if (!formKey.currentState!.validate()) {
      toastInfo(msg: "Please fill all required fields", status: Status.error);
      return;
    }

    final notifier = ref.read(completeSignupNotifierProvider.notifier);

    Utils.logger.i(
      "Registering user with email: ${countryController.text.trim()}",
    );
    Utils.logger.i("Full Name: ${cityController.text.trim()}");
    Utils.logger.d('$notifier');

    await notifier.completeRegistrations(
      address: addressController.text.trim(),
      occupation: occupationController.text.trim(),
      country: countryController.text.trim(),
      states: stateValue!,
      city: cityController.text.trim(),
      phonenumber: phoneNumberController.text.trim(),
      lga: lgaValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CompleteSignupState>(completeSignupNotifierProvider, (
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
        toastInfo(
          msg: 'Success! Account creation completed. You can now log in.',
          status: Status.completed,
        );

        context.go(AppRouter.login);
      }
    });

    final completeSignupState = ref.watch(completeSignupNotifierProvider);
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
                            'Complete Registration',
                            style: AppFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          const Gap(20),
                          AppTextField(
                            label: 'Country name',
                            controller: countryController,
                            title: 'Country',
                            obscureText: false,
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// STATE DROPDOWN
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'State',
                                      style: AppFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Select State',
                                          style: AppFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w100,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        value: stateValue,
                                        items:
                                            NigerianStatesAndLGA.allStates.map((
                                              String value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: AppFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                        selectedItemBuilder: (context) {
                                          return NigerianStatesAndLGA.allStates
                                              .map((state) {
                                                return Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    state,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                );
                                              })
                                              .toList();
                                        },
                                        onChanged: (value) {
                                          lgaValue = 'Choose an LGA';
                                          statesLga.clear();
                                          statesLga.add(lgaValue);
                                          statesLga.addAll(
                                            NigerianStatesAndLGA.getStateLGAs(
                                              value!,
                                            ),
                                          );
                                          setState(() {
                                            stateValue = value;
                                          });
                                        },
                                        style: AppFonts.poppins(fontSize: 12),
                                        buttonStyleData: ButtonStyleData(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: AppColors.softLightGrey,
                                            ),
                                          ),
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                        iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              /// LGA DROPDOWN
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'LGA',
                                      style: AppFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'Choose an LGA',
                                          style: AppFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w100,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        value: lgaValue,
                                        items:
                                            statesLga.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: AppFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                        selectedItemBuilder: (context) {
                                          return statesLga.map((lga) {
                                            return Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                lga,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            );
                                          }).toList();
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            lgaValue = value!;
                                          });
                                        },
                                        style: AppFonts.poppins(fontSize: 12),
                                        buttonStyleData: ButtonStyleData(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: AppColors.softLightGrey,
                                            ),
                                          ),
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                        iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                            label: 'Occupation',
                            controller: occupationController,
                            title: 'Occupation',
                            keyboardType: TextInputType.text,
                          ),
                          const Gap(10),
                          AppTextField(
                            label: 'Phone Number',
                            controller: phoneNumberController,
                            title: 'Phone Number',
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
                          const Gap(20),
                          Align(
                            alignment: Alignment.center,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: AuthButton(
                                color: AppColors.primaryColor,
                                text:
                                    completeSignupState.processingStatus ==
                                            ProcessingStatus.waiting
                                        ? "Completing..."
                                        : "Complete Registration",
                                onPressed:
                                    completeSignupState.processingStatus ==
                                            ProcessingStatus.waiting
                                        ? null
                                        : () {
                                          handleCompleteRegister(); // wrapped in void Function()
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
