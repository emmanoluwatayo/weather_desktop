import 'package:flutter/material.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';

Future<void> areYouSureDialog({
  required String title,
  required String content,
  required BuildContext context,
  required Function action,
  bool isIdInvolved = false,
  String id = '',
  String confirmText = 'Yes',
  String declineText = 'Cancel',
}) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: AppFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D6466),
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
            style: AppFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: AppColors.errorColor),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                declineText,
                style: AppFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.errorColor,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(color: AppColors.primaryColor),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              onPressed: () => isIdInvolved ? action(id) : action(),
              child: Text(
                confirmText,
                style: AppFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
  );
}
