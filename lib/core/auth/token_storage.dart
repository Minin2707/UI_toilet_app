import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {

  static const _storage =
      FlutterSecureStorage();

  static const _accessTokenKey =
      'access_token';

  static const _refreshTokenKey =
      'refresh_token';

  Future<void> saveAccessToken(
      String token,
      ) async {

    await _storage.write(

      key: _accessTokenKey,

      value: token,
    );
  }

  Future<void> saveRefreshToken(
      String token,
      ) async {

    await _storage.write(

      key: _refreshTokenKey,

      value: token,
    );
  }

  Future<String?> getAccessToken() async {

    try {

      return await _storage.read(
        key: _accessTokenKey,
      );

    } on PlatformException {

      try {

        await _storage.deleteAll();

      } catch (_) {}

      return null;
    }
  }

  Future<String?> getRefreshToken() async {

    try {

      return await _storage.read(
        key: _refreshTokenKey,
      );

    } on PlatformException {

      try {

        await _storage.deleteAll();

      } catch (_) {}

      return null;
    }
  }

  Future<void> clearTokens() async {

    await _storage.delete(
      key: _accessTokenKey,
    );

    await _storage.delete(
      key: _refreshTokenKey,
    );
  }
}