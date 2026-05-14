import 'package:dio/dio.dart';

import '../auth/token_storage.dart';

class AuthInterceptor extends Interceptor {

  final TokenStorage _tokenStorage =
      TokenStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {

    final token =
        await _tokenStorage.getToken();

    if (token != null &&
        token.isNotEmpty) {
        print(
            'JWT ATTACHED = $token',
          );

      options.headers['Authorization'] =
          'Bearer $token';
    }

    return handler.next(options);
  }
}