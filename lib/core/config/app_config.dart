import 'package:flutter/foundation.dart';

import 'environment.dart';

class AppConfig {
  final Environment environment;

  const AppConfig({
    required this.environment,
  });

  static late AppConfig instance;

  static void initialize(Environment environment) {
    instance = AppConfig(
      environment: environment,
    );
  }

  String get baseUrl {
    switch (environment) {
      case Environment.dev:
        if (kIsWeb) {
          return 'http://localhost:8080';
        }
        return 'https://argued-investors-shannon-ireland.trycloudflare.com';

      case Environment.stage:
        return 'https://stage-api.toiletmap.com';

      case Environment.prod:
        return 'https://api.toiletmap.com';
    }
  }

  String get appName {
    switch (environment) {
      case Environment.dev:
        return 'Toilet Map Dev';

      case Environment.stage:
        return 'Toilet Map Stage';

      case Environment.prod:
        return 'Toilet Map';
    }
  }

  bool get isDev => environment == Environment.dev;
}