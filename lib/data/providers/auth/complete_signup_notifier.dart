// sign_up_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_desktop/data/providers/provider.dart';
import 'package:weather_desktop/utilities/custom_error.dart';

enum ProcessingStatus { initial, waiting, success, error }

class CompleteSignupState {
  final ProcessingStatus processingStatus;
  final CustomError error;

  CompleteSignupState({required this.processingStatus, required this.error});

  CompleteSignupState copyWith({
    ProcessingStatus? processingStatus,
    CustomError? error,
  }) {
    return CompleteSignupState(
      processingStatus: processingStatus ?? this.processingStatus,
      error: error ?? this.error,
    );
  }
}

class CompleteSignupNotifier extends StateNotifier<CompleteSignupState> {
  final Ref ref;

  CompleteSignupNotifier(this.ref)
    : super(
        CompleteSignupState(
          processingStatus: ProcessingStatus.initial,
          error: CustomError.initial(),
        ),
      );

  Future<void> completeRegistrations({
    required String address,
    required String occupation,
    required String country,
    required String states,
    required String city,
    required String phonenumber,
    required String lga,
  }) async {
    state = state.copyWith(processingStatus: ProcessingStatus.waiting);

    try {
      await ref
          .read(authServiceProvider)
          .completeRegistration(
            occupation: occupation,
            address: address,
            country: country,
            state: states,
            city: city,
            phonenumber: phonenumber,
            lga: lga,
          );

      state = state.copyWith(processingStatus: ProcessingStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(
        processingStatus: ProcessingStatus.error,
        error: e,
      );
    }
  }
}

final completeSignupNotifierProvider =
    StateNotifierProvider<CompleteSignupNotifier, CompleteSignupState>((ref) {
      return CompleteSignupNotifier(ref);
    });
