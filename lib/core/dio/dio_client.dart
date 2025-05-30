import 'package:dio/dio.dart';
import 'package:weather_desktop/core/network/network_exceptions.dart';

class DioClient {
  final Dio _dio;

  DioClient(String baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ));

  Future<T> get<T>(String url, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParams);
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> post<T>(String url, dynamic data) async {
    try {
      final response = await _dio.post(url, data: data);
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> put<T>(String url, dynamic data) async {
    try {
      final response = await _dio.put(url, data: data);
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<T> delete<T>(String url) async {
    try {
      final response = await _dio.delete(url);
      return _handleResponse<T>(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  T _handleResponse<T>(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw NetworkExceptions("Error: ${response.statusCode}");
    }
  }

  NetworkExceptions _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return NetworkExceptions("Connection timeout");
        case DioExceptionType.receiveTimeout:
          return NetworkExceptions("Receive timeout");
        case DioExceptionType.badResponse:
          return NetworkExceptions("Bad response: ${error.response?.statusCode}");
        case DioExceptionType.cancel:
          return NetworkExceptions("Request cancelled");
        default:
          return NetworkExceptions("Unexpected error: ${error.message}");
      }
    }
    return NetworkExceptions("Unknown error occurred");
  }
}
