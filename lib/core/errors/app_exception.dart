class AppException
    implements Exception {

  final String code;

  final String message;

  final int? retryAfterSeconds;

  AppException({

    required this.code,

    required this.message,

    this.retryAfterSeconds,
  });
}