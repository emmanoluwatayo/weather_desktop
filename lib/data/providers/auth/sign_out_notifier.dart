import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_desktop/data/providers/provider.dart';
import 'package:weather_desktop/utilities/custom_error.dart';

enum ProcessingStatus { initial, waiting, success, error }

class SignOutState {
  final ProcessingStatus processingStatus;
  final CustomError error;

  SignOutState({required this.processingStatus, required this.error});

  SignOutState copyWith({
    ProcessingStatus? processingStatus,
    CustomError? error,
  }) {
    return SignOutState(
      processingStatus: processingStatus ?? this.processingStatus,
      error: error ?? this.error,
    );
  }
}

class SignOutNotifier extends StateNotifier<SignOutState> {
  final Ref ref;

  SignOutNotifier(this.ref)
    : super(
        SignOutState(
          processingStatus: ProcessingStatus.initial,
          error: CustomError.initial(),
        ),
      );

  Future<void> signOut() async {
    state = state.copyWith(processingStatus: ProcessingStatus.waiting);

    try {
      await ref.read(authServiceProvider).signOut();
      state = state.copyWith(processingStatus: ProcessingStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(
        processingStatus: ProcessingStatus.error,
        error: e,
      );
    }
  }
}

final signOutNotifierProvider =
    StateNotifierProvider<SignOutNotifier, SignOutState>((ref) {
      return SignOutNotifier(ref);
    });
