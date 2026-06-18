import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static bool _wasResetAfterPlatformException =
      false;

  static const _accessTokenKey = 'access_token';

  static const _refreshTokenKey = 'refresh_token';

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
      await _resetAfterPlatformException();

      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(
        key: _refreshTokenKey,
      );
    } on PlatformException {
      await _resetAfterPlatformException();

      return null;
    }
  }

  bool consumeWasResetAfterPlatformException() {
    final value = _wasResetAfterPlatformException;

    _wasResetAfterPlatformException = false;

    return value;
  }

  Future<void> clearTokens() async {
    await _storage.delete(
      key: _accessTokenKey,
    );

    await _storage.delete(
      key: _refreshTokenKey,
    );
  }

  Future<void> _resetAfterPlatformException() async {
    _wasResetAfterPlatformException = true;

    try {
      await _storage.deleteAll();
    } catch (_) {}
  }
}
