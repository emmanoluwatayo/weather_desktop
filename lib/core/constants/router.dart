import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_desktop/presentation/screens/entry_screen.dart';
import 'package:weather_desktop/presentation/screens/forget_password/forget_password.dart';
import 'package:weather_desktop/presentation/screens/login/login_screen.dart';
import 'package:weather_desktop/presentation/screens/navigation_page/navigation_page.dart';
import 'package:weather_desktop/presentation/screens/registration/complete_registration.dart';
import 'package:weather_desktop/presentation/screens/registration/registration_screen.dart';

class AppRouter {
  // Static Route Paths
  static const String splash = '/entryScreen';
  static const String login = '/login';
  static const String register = '/register';
  static const String completeRegistration = '/completeRegistration';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String terms = '/terms';
  static const String forgotPassword = '/forgotPassword';
  static const String navigationPage = '/navigationPage';

  // GoRouter Instance
  static final GoRouter router = GoRouter(
    initialLocation: splash, // <-- Set your starting page
    routes: <GoRoute>[
      GoRoute(
        path: splash,
        builder:
            (BuildContext context, GoRouterState state) => const EntryScreen(),
      ),
      GoRoute(
        path: register,
        builder:
            (BuildContext context, GoRouterState state) =>
                const RegistrationScreen(),
      ),
      GoRoute(
        path: login,
        builder:
            (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: completeRegistration,
        builder:
            (BuildContext context, GoRouterState state) =>
                const CompleteRegistration(),
      ),
      GoRoute(
        path: forgotPassword,
        builder:
            (BuildContext context, GoRouterState state) =>
                const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: navigationPage,
        builder:
            (BuildContext context, GoRouterState state) =>
                const NavigationPage(),
      ),
      // GoRoute(
      //   path: home,
      //   builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      // ),
      // GoRoute(
      //   path: profile,
      //   builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
      // ),
      // GoRoute(
      //   path: settings,
      //   builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
      // ),
      // GoRoute(
      //   path: about,
      //   builder: (BuildContext context, GoRouterState state) => const AboutScreen(),
      // ),
      // GoRoute(
      //   path: contact,
      //   builder: (BuildContext context, GoRouterState state) => const ContactScreen(),
      // ),
      // GoRoute(
      //   path: terms,
      //   builder: (BuildContext context, GoRouterState state) => const TermsScreen(),
      // ),
      // GoRoute(
      //   path: privacy,
      //   builder: (BuildContext context, GoRouterState state) => const PrivacyScreen(),
      // ),
    ],
  );
}
