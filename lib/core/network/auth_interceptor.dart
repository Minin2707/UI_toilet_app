import 'package:dio/dio.dart';

import '../auth/token_storage.dart';
import '../config/app_config.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage = TokenStorage();

  bool _isRefreshing = false;

  Future<String?>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print(
      'INTERCEPTOR: ${options.method} ${options.uri}',
    );

    final accessToken =
        await _tokenStorage.getAccessToken();

    if (accessToken != null &&
        accessToken.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    try {
      String? accessToken;

      if (_isRefreshing) {
        accessToken =
            await _refreshFuture;
      } else {
        _isRefreshing = true;

        try {
          _refreshFuture =
              _refreshAccessToken();

          accessToken =
              await _refreshFuture;
        } finally {
          _isRefreshing = false;
          _refreshFuture = null;
        }
      }

      if (accessToken == null) {
        await _tokenStorage.clearTokens();

        return handler.next(err);
      }

      final requestOptions =
          err.requestOptions;

      requestOptions.headers['Authorization'] =
          'Bearer $accessToken';

      final dio = Dio(
        BaseOptions(
          baseUrl:
              requestOptions.baseUrl,
        ),
      );

      final response =
          await dio.fetch(
        requestOptions,
      );

      return handler.resolve(
        response,
      );
    } catch (_) {
      _isRefreshing = false;
      _refreshFuture = null;

      await _tokenStorage.clearTokens();

      return handler.next(err);
    }
  }

  Future<String?> _refreshAccessToken() async {
    try {
      final refreshToken =
          await _tokenStorage
              .getRefreshToken();

      if (refreshToken == null) {
        return null;
      }

      final dio = Dio();

      final response =
          await dio.post(
        '${AppConfig.instance.baseUrl}/auth/refresh',
        data: {
          'refreshToken':
              refreshToken,
        },
      );

      if (response.data
          is! Map<String, dynamic>) {
        return null;
      }

      final data =
          response.data
              as Map<String, dynamic>;

      final newAccessToken =
          data['accessToken']
              as String?;

      final newRefreshToken =
          data['refreshToken']
              as String?;

      if (newAccessToken == null ||
          newRefreshToken == null) {
        return null;
      }

      await _tokenStorage
          .saveAccessToken(
        newAccessToken,
      );

      await _tokenStorage
          .saveRefreshToken(
        newRefreshToken,
      );

      return newAccessToken;
    } catch (_) {
      return null;
    }
  }
}