import 'package:dio/dio.dart';

import '../auth/token_storage.dart';

class AuthInterceptor extends Interceptor {

  final TokenStorage _tokenStorage =
      TokenStorage();

    @override
    Future<void> onRequest(
        RequestOptions options,
        RequestInterceptorHandler handler,
        ) async {

    final token =
        await _tokenStorage.getToken();

    if (token != null &&
        token.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer $token';
    }

    return handler.next(options);
  }
}