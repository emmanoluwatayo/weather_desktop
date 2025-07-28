import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/router.dart';
import 'package:weather_desktop/firebase_options.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_desktop/utilities/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.primaryColor.withValues(alpha: 0.4),
      ),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LoaderOverlay(
        // ignore: deprecated_member_use
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) {
          return const Center(
            child: SpinKitCircle(color: AppColors.primaryColor, size: 50.0),
          );
        },
        child: MaterialApp.router(
          title: 'Weather APP',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          routerConfig: AppRouter.router, // connect your GoRouter here
        ),
      ),
    );
  }
}
