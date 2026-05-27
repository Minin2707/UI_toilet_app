import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/localization/locale_cubit.dart';
import '../core/localization/locale_state.dart';
import '../l10n/app_localizations.dart';
import '../core/auth/token_storage.dart';
import '../core/config/app_config.dart';

import 'router/app_router.dart';

class ToiletMapApp extends StatefulWidget {

  const ToiletMapApp({
    super.key,
  });

  @override
  State<ToiletMapApp> createState() =>
      _ToiletMapAppState();
}

class _ToiletMapAppState
    extends State<ToiletMapApp> {

  late final AppLinks _appLinks;

  StreamSubscription? _sub;

  @override
  void initState() {

    super.initState();

    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {

    _appLinks = AppLinks();

    final initialUri =
        await _appLinks.getInitialLink();

    if (initialUri != null) {

      await _handleDeepLink(
          initialUri,
      );
    }

    _sub = _appLinks.uriLinkStream.listen(

      (uri) async {

        await _handleDeepLink(uri);
      },
    );
  }

  Future<void> _handleDeepLink(
      Uri uri,
  ) async {

    if (uri.scheme == 'toiletmap' &&
        uri.host == 'auth') {

      final tokensJson =
          uri.queryParameters['tokens'];

      if (tokensJson != null &&
          tokensJson.isNotEmpty) {

        final data =
            jsonDecode(tokensJson);

        final accessToken =
            data['accessToken'];

        final refreshToken =
            data['refreshToken'];

        await TokenStorage()
            .saveAccessToken(
                accessToken,
            );

        await TokenStorage()
            .saveRefreshToken(
                refreshToken,
            );

        debugPrint(
          'TOKENS SAVED',
        );

        if (mounted) {

          appRouter.go('/');
        }
      }
    }
  }

  @override
  void dispose() {

    _sub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<
          LocaleCubit,
          LocaleState>(

        builder: (
          context,
          state,
        ) {

          debugPrint(
            'APP REBUILD LOCALE = ${state.languageCode}',
          );

          return MaterialApp.router(

            title:
                AppConfig.instance.appName,

            debugShowCheckedModeBanner:
                false,

            routerConfig: appRouter,

            locale: Locale(
              state.languageCode,
            ),

            localeResolutionCallback:
                (
                  locale,
                  supportedLocales,
                ) {

              return Locale(
                state.languageCode,
              );
            },

            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
            ],

            localizationsDelegates:
                AppLocalizations.localizationsDelegates,

            theme: ThemeData(

              colorSchemeSeed:
                  Colors.blue,

              useMaterial3: true,
            ),
          );
        },
    );
  }
}