class AppException
    implements Exception {

  final String code;

  final String message;

  AppException({

    required this.code,

    required this.message,
  });
}