import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../network/auth_interceptor.dart';

class ApiClient {

  static Dio createDio() {

    return Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.baseUrl,

        connectTimeout:
            const Duration(seconds: 30),

        receiveTimeout:
            const Duration(seconds: 30),
      ),
    )..interceptors.add(
        AuthInterceptor(),
      );
  }
}