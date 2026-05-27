import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/auth/token_storage.dart';

import '../../data/repositories/auth_repository.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  final TokenStorage _tokenStorage =
      TokenStorage();

  final AuthRepository _authRepository =
      AuthRepository();

  @override
  void initState() {

    super.initState();

    _bootstrap();
  }

  Future<void> _bootstrap() async {

    debugPrint(
      'BOOTSTRAP START',
    );

    final token =
        await _tokenStorage.getAccessToken();

    debugPrint(
      'TOKEN = $token',
    );

    // NO TOKEN

    if (token == null ||
        token.isEmpty) {

      if (!mounted) return;

      context.go('/auth');

      return;
    }

    // VALIDATE TOKEN

    final valid =
        await _authRepository
            .validateToken();

    debugPrint(
      'TOKEN VALID = $valid',
    );

    // INVALID TOKEN

    if (!valid) {

      await _tokenStorage.clearTokens();

      if (!mounted) return;

      context.go('/auth');

      return;
    }

    // VALID TOKEN

    if (!mounted) return;

    context.go('/map');
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(

        child:
            CircularProgressIndicator(),
      ),
    );
  }
}