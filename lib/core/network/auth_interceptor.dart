import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../auth/token_storage.dart';

class AuthInterceptor extends Interceptor {

  final TokenStorage _tokenStorage =
      TokenStorage();

  bool _isRefreshing = false;

  Future<String?>? _refreshFuture;

  @override
  Future<void> onRequest(

      RequestOptions options,

      RequestInterceptorHandler handler,
  ) async {

    final accessToken =

        await _tokenStorage
            .getAccessToken();

    if (accessToken != null &&
        accessToken.isNotEmpty) {

      options.headers['Authorization'] =

          'Bearer $accessToken';
    }

    return handler.next(options);
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

        _refreshFuture =
            _refreshAccessToken();

        accessToken =
            await _refreshFuture;

        _isRefreshing = false;
      }

      if (accessToken == null) {

        await _tokenStorage
            .clearTokens();

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

      await _tokenStorage
          .clearTokens();

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

      final newAccessToken =

          response.data['accessToken'];

      final newRefreshToken =

          response.data['refreshToken'];

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