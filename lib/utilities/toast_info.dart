import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/network/api_response.dart';

toastInfo({
  required String msg,
  required Status status,
}) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    webBgColor: status == Status.error
        // ignore: deprecated_member_use
        ? 'rgba(${AppColors.errorColor.red}, ${AppColors.errorColor.green}, ${AppColors.errorColor.blue}, ${AppColors.errorColor.opacity})'
        // ignore: deprecated_member_use
        : 'rgba(${AppColors.primaryColor.red}, ${AppColors.primaryColor.green}, ${AppColors.primaryColor.blue}, ${AppColors.primaryColor.opacity})',
  );
}