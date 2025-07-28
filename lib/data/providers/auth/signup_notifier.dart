// sign_up_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_desktop/data/providers/provider.dart';
import 'package:weather_desktop/presentation/utilities/utils.dart';
import 'package:weather_desktop/utilities/custom_error.dart';

enum ProcessingStatus { initial, waiting, success, error }

class SignUpState {
  final ProcessingStatus processingStatus;
  final CustomError error;

  SignUpState({required this.processingStatus, required this.error});

  SignUpState copyWith({
    ProcessingStatus? processingStatus,
    CustomError? error,
  }) {
    return SignUpState(
      processingStatus: processingStatus ?? this.processingStatus,
      error: error ?? this.error,
    );
  }
}

class SignUpNotifier extends StateNotifier<SignUpState> {
  final Ref ref;

  SignUpNotifier(this.ref)
    : super(
        SignUpState(
          processingStatus: ProcessingStatus.initial,
          error: CustomError.initial(),
        ),
      );

  Future<void> registerWithEmailAndPassword({
    required String emailAddress,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(processingStatus: ProcessingStatus.waiting);

    try {
      await ref
          .read(authServiceProvider)
          .registerWithEmailAndPassword(
            emailAddress: emailAddress,
            password: password,
            fullName: fullName,
          );

      state = state.copyWith(processingStatus: ProcessingStatus.success);
    } on CustomError catch (e) {
      Utils.logger.i("❌ Registration Error: ${e.errorMsg}");
      state = state.copyWith(
        processingStatus: ProcessingStatus.error,
        error: e,
      );
    }
  }
}

final signUpNotifierProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
      return SignUpNotifier(ref);
    });
