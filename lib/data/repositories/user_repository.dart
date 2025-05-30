import 'package:dio/dio.dart';
// import 'package:weather_desktop/core/network/network_exceptions.dart';

class UserRepository {
  final Dio dio;

  UserRepository({required this.dio});

  // Future<User> getUserProfile(String userId) async {
  //   try {
  //     final response = await dio.get('/users/$userId');
  //     return User.fromJson(response.data);
  //   } catch (e) {
  //     throw NetworkExceptions('Failed to load user profile');
  //   }
  // }

  // Future<void> updateUserProfile(User user) async {
  //   try {
  //     await dio.put('/users/${user.id}', data: user.toJson());
  //   } catch (e) {
  //     throw NetworkExceptions('Failed to update user profile');
  //   }
  // }

  // Add more user-related methods here
}
