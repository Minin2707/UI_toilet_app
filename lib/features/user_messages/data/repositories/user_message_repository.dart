import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';

import '../models/user_message_request.dart';

class UserMessageRepository {

  final Dio _dio =
      ApiClient.createDio();

  Future<void> send(
    UserMessageRequest request,
  ) async {

    await _dio.post(
      '/user-messages',
      data: request.toJson(),
    );
  }
}