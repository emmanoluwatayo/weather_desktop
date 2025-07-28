// auth_service.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:weather_desktop/presentation/utilities/utils.dart';
import 'package:weather_desktop/utilities/custom_error.dart';

class AuthService {
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseAnalytics analytics;

  AuthService({
    required this.firebaseAuth,
    required this.firestore,
    required this.analytics,
  });

  Stream<fb_auth.User?> get user => firebaseAuth.userChanges();

  String error = "Error occurred!";

  Future<void> _checkEmailVerification(fb_auth.User user) async {
    if (!user.emailVerified) {
      await user.sendEmailVerification();
      throw const CustomError(
        errorMsg: "Email not verified. A verification email has been sent.",
        code: "email-not-verified",
        plugin: "firebase-auth",
      );
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required String fullName,
  }) async {
    try {
      Utils.logger.i("🔥 AuthService.registerWithEmailAndPassword CALLED");
      final fb_auth.UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );

      final fb_auth.User? user = credential.user;
      await user!.sendEmailVerification(); // send email verification
      try {
        await firestore.collection('users').doc(user.uid).set({
          'fullname': fullName,
          'email': emailAddress,
          'metadata': {
            'creation_time':
                user.metadata.creationTime?.toIso8601String() ?? '',
            'last_sign_in_time':
                user.metadata.lastSignInTime?.toIso8601String() ?? '',
          },
        });
        Utils.logger.i("✅ Firestore user created successfully");
      } catch (e) {
        Utils.logger.e("❌ Failed to save user to Firestore: $e");
      }

      if (kDebugMode) {
        print("User registered: $user");
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.message != null) {
        error = _mapFirebaseAuthError(e.code);
      }
      throw CustomError(errorMsg: error, code: e.code, plugin: e.plugin);
    }
  }

  Future<void> completeRegistration({
    required String occupation,
    required String address,
    required String country,
    required String state,
    required String city,
    required String phonenumber,
    required String lga,
  }) async {
    try {
      final user = fb_auth.FirebaseAuth.instance.currentUser;

      if (user != null) {
        await firestore.collection('users').doc(user.uid).update({
          'occupation': occupation,
          'address': address,
          'country': country,
          'state': state,
          'city': city,
          'phonenumber': phonenumber,
          'lga': lga,
        });

        if (kDebugMode) {
          print("User details updated for user: $user");
        }
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.message != null) {
        error = _mapFirebaseAuthError(e.code);
      }
      throw CustomError(errorMsg: error, code: e.code, plugin: e.plugin);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final fb_auth.UserCredential credential = await firebaseAuth
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      final fb_auth.User? user = credential.user;

      if (user != null) {
        await _checkEmailVerification(user);
      }

      if (kDebugMode) {
        print("User signed in: $user");
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.message != null) {
        error = _mapFirebaseAuthError(e.code);
      }
      throw CustomError(errorMsg: error, code: e.code, plugin: e.plugin);
    }
  }

  Future<void> uploadProfileImage({
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      final user = fb_auth.FirebaseAuth.instance.currentUser;
      final FirebaseStorage storage = FirebaseStorage.instance;

      if (user == null) {
        throw const CustomError(
          errorMsg: "No authenticated user found.",
          code: "user-not-authenticated",
          plugin: "firebase-auth",
        );
      }

      final storageRef = storage.ref().child(
        'profile_images/${user.uid}/${DateTime.now().toIso8601String()}',
      );

      if (imageBytes != null) {
        if (kDebugMode) print('Uploading image bytes...');
        await storageRef.putData(imageBytes);
        if (kDebugMode) print('Image bytes uploaded successfully.');
      } else if (imageFile != null) {
        if (kDebugMode) print('Uploading image file...');
        await storageRef.putFile(imageFile);
        if (kDebugMode) print('Image file uploaded successfully.');
      } else {
        throw const CustomError(
          errorMsg: "No image data provided.",
          code: "invalid-input",
          plugin: "uploadProfileImage",
        );
      }

      final String imageUrl = await storageRef.getDownloadURL();
      if (kDebugMode) print('Image URL: $imageUrl');

      await firestore.collection('users').doc(user.uid).update({
        'profile_image': imageUrl,
      });
      if (kDebugMode) print('Firestore updated successfully with image URL.');
    } catch (e) {
      if (kDebugMode) print('Error uploading profile image: $e');
      throw CustomError(
        errorMsg: "Failed to upload profile image or update profile.",
        code: e.toString(),
        plugin: "firebase-storage/firebase-firestore",
      );
    }
  }

  // Future<void> _uploadImageBytes(
  //     Reference storageRef, Uint8List imageBytes) async {
  //   await storageRef.putData(imageBytes);
  // }

  // Future<void> _uploadImageFile(Reference storageRef, File imageFile) async {
  //   await storageRef.putFile(imageFile);
  // }

  Future<void> forgotPassword({required String emailAddress}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: emailAddress);

      if (kDebugMode) {
        print("Password reset email sent to: $emailAddress");
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.message != null) {
        error = _mapFirebaseAuthError(e.code);
      }
      throw CustomError(errorMsg: error, code: e.code, plugin: e.plugin);
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();

      if (kDebugMode) {
        print("User signed out");
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.message != null) {
        error = _mapFirebaseAuthError(e.code);
      }
      throw CustomError(errorMsg: error, code: e.code, plugin: e.plugin);
    }
  }

  Stream<Map<String, dynamic>> fetchUserDetails() {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return {};
      }
      return doc.data()!;
    });
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return "Email not recognized!";
      case 'invalid-email':
        return "Invalid email address!";
      case 'email-already-in-use':
        return "Email already in use!";
      case 'network-request-failed':
        return "Network error, check your connection!";
      case 'wrong-password':
        return "Incorrect password!";
      default:
        return kIsWeb
            ? "An error occurred on the Web platform: $code"
            : "An error occurred: $code";
    }
  }
}
