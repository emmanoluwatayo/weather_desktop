import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_desktop/data/providers/provider.dart';
import 'package:weather_desktop/infrastructure/weather/model/weather_model.dart';
import 'package:weather_desktop/utilities/custom_error.dart';

enum ProcessingStatus { initial, waiting, success, error }

class WeatherState {
  final ProcessingStatus processingStatus;
  final CustomError error;
  final WeatherModel? data;

  WeatherState({
    required this.processingStatus,
    required this.error,
    this.data,
  });

  WeatherState copyWith({
    ProcessingStatus? processingStatus,
    CustomError? error,
    WeatherModel? data,
  }) {
    return WeatherState(
      processingStatus: processingStatus ?? this.processingStatus,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  factory WeatherState.initial() {
    return WeatherState(
      processingStatus: ProcessingStatus.initial,
      error: CustomError.initial(),
      data: null,
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final Ref ref;

  WeatherNotifier(this.ref) : super(WeatherState.initial());

  Future<void> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(processingStatus: ProcessingStatus.waiting);

    try {
      final weatherService = ref.read(weatherServiceProvider);
      final weatherData = await weatherService.fetchCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      );

      state = state.copyWith(
        processingStatus: ProcessingStatus.success,
        data: weatherData,
      );
    } on CustomError catch (e) {
      state = state.copyWith(
        processingStatus: ProcessingStatus.error,
        error: e,
      );
    } catch (e) {
      state = state.copyWith(
        processingStatus: ProcessingStatus.error,
        error: CustomError(
          errorMsg: 'Unexpected error: ${e.toString()}',
          code: e.toString(),
          plugin: e.toString(),
        ),
      );
    }
  }
}

final weatherNotifierProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
      return WeatherNotifier(ref);
    });
