// sign_up_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_desktop/data/providers/provider.dart';
import 'package:weather_desktop/utilities/custom_error.dart';

enum ProcessingStatus { initial, waiting, success, error }

class SignInState {
  final ProcessingStatus processingStatus;
  final CustomError error;

  SignInState({required this.processingStatus, required this.error});

  SignInState copyWith({
    ProcessingStatus? processingStatus,
    CustomError? error,
  }) {
    return SignInState(
      processingStatus: processingStatus ?? this.processingStatus,
      error: error ?? this.error,
    );
  }
}

class SignInNotifier extends StateNotifier<SignInState> {
  final Ref ref;

  SignInNotifier(this.ref)
    : super(
        SignInState(
          processingStatus: ProcessingStatus.initial,
          error: CustomError.initial(),
        ),
      );

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(processingStatus: ProcessingStatus.waiting);

    try {
      await ref
          .read(authServiceProvider)
          .signInWithEmailAndPassword(emailAddress: email, password: password);

      state = state.copyWith(processingStatus: ProcessingStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(
        processingStatus: ProcessingStatus.error,
        error: e,
      );
    }
  }
}

final signInNotifierProvider =
    StateNotifierProvider<SignInNotifier, SignInState>((ref) {
      return SignInNotifier(ref);
    },);
