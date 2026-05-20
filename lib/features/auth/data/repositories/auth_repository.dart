import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';

class AuthRepository {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> startRegistration({
    required String username,
  }) async {
    final response = await _dio.post(
      '/auth/register/start',
      data: {
        'username': username,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<String> finishRegistration({
    required Map<String, dynamic> credential,
    required String username,
  }) async {
    final response = await _dio.post(
      '/auth/register/finish',
      data: {
        'username': username,
        'credential': credential,
      },
    );

    return response.data as String;
  }

  Future<bool> validateToken() async {

    try {

      final response =
          await _dio.get('/auth/me');

      return response.statusCode == 200;

    } catch (_) {

      return false;
    }
  }
}