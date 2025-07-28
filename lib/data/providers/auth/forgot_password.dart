// sign_up_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_desktop/data/providers/provider.dart';
import 'package:weather_desktop/utilities/custom_error.dart';

enum ProcessingStatus { initial, waiting, success, error }

class ForgotPasswordState {
  final ProcessingStatus processingStatus;
  final CustomError error;

  ForgotPasswordState({required this.processingStatus, required this.error});

  ForgotPasswordState copyWith({
    ProcessingStatus? processingStatus,
    CustomError? error,
  }) {
    return ForgotPasswordState(
      processingStatus: processingStatus ?? this.processingStatus,
      error: error ?? this.error,
    );
  }
}

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final Ref ref;

  ForgotPasswordNotifier(this.ref)
    : super(
        ForgotPasswordState(
          processingStatus: ProcessingStatus.initial,
          error: CustomError.initial(),
        ),
      );

  Future<void> forgetPassword({required String email}) async {
    state = state.copyWith(processingStatus: ProcessingStatus.waiting);

    try {
      await ref
          .read(authServiceProvider)
          .forgotPassword(emailAddress: email);

      state = state.copyWith(processingStatus: ProcessingStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(
        processingStatus: ProcessingStatus.error,
        error: e,
      );
    }
  }
}

final forgotPasswordNotifierProvider =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
      return ForgotPasswordNotifier(ref);
    },);
