import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/auth/token_storage.dart';

import '../../data/repositories/auth_repository.dart';
import '../../../onboarding/data/onboarding_storage.dart';

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

    if (_tokenStorage
        .consumeWasResetAfterPlatformException()) {
      await OnboardingStorage().reset();
    }

    debugPrint(
      'TOKEN = $token',
    );

    // NO TOKEN

    if (token == null ||
        token.isEmpty) {

      WidgetsBinding.instance
          .addPostFrameCallback((_) {

        if (!mounted) return;

        context.go('/auth');
      });

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

    final completed =
        await OnboardingStorage()
            .isCompleted();

    if (!mounted) {
      return;
    }

    if (completed) {

      context.go('/map');

    } else {

      context.go('/onboarding');
    }
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
