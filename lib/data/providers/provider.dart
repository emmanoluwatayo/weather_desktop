// providers.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_desktop/core/dio/dio_provider.dart';
import 'package:weather_desktop/infrastructure/authentication/authser.dart';
import 'package:weather_desktop/infrastructure/weather/weather_service.dart';
import 'package:weather_desktop/presentation/utilities/utils.dart';

final firebaseAuthProvider = Provider<fb_auth.FirebaseAuth>((ref) {
  return fb_auth.FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAnalyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});

final authServiceProvider = Provider<AuthService>((ref) {
  Utils.logger.i("📦 authServiceProvider initialized");
  return AuthService(
    firebaseAuth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firestoreProvider),
    analytics: ref.read(firebaseAnalyticsProvider),
  );
});

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).user;
});

// Auth user StreamProvider
final userDetailsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(authServiceProvider).fetchUserDetails();
});

// Weather service provider
final weatherServiceProvider = Provider<WeatherService>((ref) {
  final dio = ref.read(dioClientProvider);
  return WeatherService(dioClient: dio);
});
