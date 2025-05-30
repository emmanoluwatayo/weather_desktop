import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text("Profile Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.white,
      ),
      body: Padding(
  padding: const EdgeInsets.all(24),
  child: ListView(
    children: [
      Center(
        child: Stack(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/default_avatar.png'),
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
      _infoTile(label: "Full Name", value: "John Doe"),
      const Gap(16),
      _infoTile(label: "Email", value: "johndoe@example.com"),
      const Gap(16),
      _infoTile(label: "Default City", value: "New York"),
      const Gap(32),
      const Divider(color: Colors.white24),
      const Gap(16),
      _customSwitchTile("Temperature Unit", "Celsius (°C)"),
      _customSwitchTile("Distance Unit", "Kilometers (km)"),
      _customSwitchTile("App Theme", "Dark Mode"),
    ],
  ),
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
