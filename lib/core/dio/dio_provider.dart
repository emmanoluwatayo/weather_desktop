import 'package:weather_desktop/core/dio/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient('https://yourapi.com/api');
});
