import 'package:weather_desktop/core/dio/dio_client.dart';
import 'package:weather_desktop/core/network/network_exceptions.dart';
import 'package:weather_desktop/infrastructure/weather/model/weather_model.dart';

class WeatherService {
  final DioClient dioClient;

  WeatherService({required this.dioClient});

  Future<WeatherModel> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dioClient.get<Map<String, dynamic>>(
        '/forecast',
        queryParams: {
          'latitude': latitude,
          'longitude': longitude,
          'current_weather': true,
          'hourly':
              'temperature_2m,relative_humidity_2m,precipitation,weathercode,windspeed_10m',
          'daily':
              'temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum',
          'timezone': 'auto',
        },
      );
      return WeatherModel.fromJson(response);
    } on NetworkExceptions catch (e) {
      // log or report this error
      throw NetworkExceptions('Network error: ${e.message}');
    } catch (e) {
      // Catch any unexpected issue (like JSON decode errors)
      throw NetworkExceptions('Unexpected error: ${e.toString()}');
    }
  }
}
