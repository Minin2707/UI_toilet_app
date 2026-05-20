import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';

import 'core/auth/token_storage.dart';
import 'core/config/app_config.dart';
import 'core/config/environment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(
    Environment.dev,
  );

  runApp(
    const AppRoot(),
  );
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() =>
      _AppRootState();
}

class _AppRootState extends State<AppRoot> {

  final AppLinks _appLinks =
      AppLinks();

  final TokenStorage _tokenStorage =
      TokenStorage();

  StreamSubscription<Uri>? _subscription;

  @override
  void initState() {
    super.initState();

    _listenDeepLinks();
  }

  Future<void> _listenDeepLinks() async {
    final initialUri =
        await _appLinks.getInitialLink();

    if (initialUri != null) {

      debugPrint(
        'INITIAL DEEPLINK = $initialUri',
      );

      final token =
          initialUri.queryParameters['token'];

      if (token != null &&
          token.isNotEmpty) {

        await _tokenStorage.saveToken(
          token,
        );

        debugPrint(
          'INITIAL JWT SAVED = $token',
        );

        if (mounted) {

          appRouter.go('/map');
        }
      }
    }

    _subscription =
        _appLinks.uriLinkStream.listen(
              (uri) async {

            debugPrint(
              'DEEPLINK = $uri',
            );

            final token =
                uri.queryParameters['token'];

            if (token == null) {
              return;
            }

            // save JWT
            await _tokenStorage.saveToken(
              token,
            );

            debugPrint(
              'JWT SAVED = $token',
            );

            if (!mounted) {
              return;
            }

            appRouter.go('/map');
          },
        );
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const ToiletMapApp();
  }
}