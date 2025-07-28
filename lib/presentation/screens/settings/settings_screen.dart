import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/data/providers/provider.dart';
import 'package:weather_desktop/utilities/app_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetailsAsync = ref.watch(userDetailsProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text("Profile Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.white,
      ),
      body: userDetailsAsync.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('No user data found.'));
          }
          final fullName = data['fullname'] ?? 'N/A';
          final email = data['email'] ?? 'N/A';
          final phoneNumber = data['phonenumber'] ?? 'N/A';
          final defaultCity = data['city'] ?? 'N/A';
          final defaultCountry = data['country'] ?? 'N/A';
          final defaultState = data['state'] ?? 'N/A';
          final defaultAddress = data['address'] ?? 'N/A';
          final defaultLGA = data['lga'] ?? 'N/A';
          final occupation = data['occupation'] ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                          'assets/default_avatar.png',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blueAccent,
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(32),
                _infoTile(label: "Full Name", value: "$fullName"),
                const Gap(16),
                _infoTile(label: "Email", value: "$email"),
                const Gap(16),
                _infoTile(label: "Phone Number", value: "$phoneNumber"),
                const Gap(16),
                _infoTile(label: "Occupation", value: "$occupation"),
                const Gap(16),
                _infoTile(label: "Default Address", value: "$defaultAddress"),
                const Gap(16),
                Row(
                  children: [
                    Expanded(
                      child: _infoTile(
                        label: "Default Country",
                        value: "$defaultCountry",
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: _infoTile(
                        label: "Default State",
                        value: "$defaultState",
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Row(
                  children: [
                    Expanded(
                      child: _infoTile(
                        label: "Default City",
                        value: "$defaultCity",
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: _infoTile(
                        label: "Default Lga",
                        value: "$defaultLGA",
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                _customSwitchTile("Temperature Unit", "Celsius (°C)"),
                _customSwitchTile("Distance Unit", "Kilometers (km)"),
                _customSwitchTile("App Theme", "Dark Mode"),
              ],
            ),
          );
        },
        loading:
            () => const Center(
              child: SpinKitCircle(color: AppColors.primaryColor),
            ),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }

  Widget _infoTile({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.poppins(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customSwitchTile(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        value: true,
        onChanged: null, // For now, static
        title: Text(
          title,
          style: AppFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppFonts.poppins(color: Colors.white54, fontSize: 12),
        ),
        inactiveTrackColor: Colors.grey.shade700,
        activeColor: Colors.blueAccent,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
