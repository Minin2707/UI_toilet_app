import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'core/localization/locale_cubit.dart';
import 'core/auth/token_storage.dart';
import 'core/config/app_config.dart';
import 'core/config/environment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(
    Environment.dev,
  );

  runApp(

    BlocProvider(

      create: (_) => LocaleCubit(),

      child: const AppRoot(),
    ),
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

      final tokensJson =
          initialUri.queryParameters['tokens'];

      if (tokensJson != null &&
          tokensJson.isNotEmpty) {

        final data =
            jsonDecode(tokensJson);

        final accessToken =
            data['accessToken'];

        final refreshToken =
            data['refreshToken'];

        await _tokenStorage
            .saveAccessToken(
                accessToken,
            );

        await _tokenStorage
            .saveRefreshToken(
                refreshToken,
            );

        debugPrint(
          'TOKENS SAVED',
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

            final tokensJson =
                uri.queryParameters['tokens'];

            if (tokensJson == null ||
                tokensJson.isEmpty) {

              return;
            }

            final data =
                jsonDecode(tokensJson);

            final accessToken =
                data['accessToken'];

            final refreshToken =
                data['refreshToken'];

            await _tokenStorage
                .saveAccessToken(
                    accessToken,
                );

            await _tokenStorage
                .saveRefreshToken(
                    refreshToken,
                );

            debugPrint(
              'TOKENS SAVED',
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