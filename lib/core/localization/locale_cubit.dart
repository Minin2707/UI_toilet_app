import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_state.dart';

class LocaleCubit
    extends Cubit<LocaleState> {

  LocaleCubit()
      : super(
          LocaleState(
            PlatformDispatcher
                    .instance
                    .locale
                    .languageCode ==
                'ru'
                ? 'ru'
                : 'en',
          ),
        ) {

    loadLocale();
  }

  Future<void> loadLocale() async {

    final prefs =
        await SharedPreferences.getInstance();

    final savedLocale =
        prefs.getString('locale');

    if (savedLocale != null) {

      emit(
        LocaleState(savedLocale),
      );
    }
  }

  Future<void> toggleLocale() async {

    final newLocale =
        state.languageCode == 'ru'
            ? 'en'
            : 'ru';

    debugPrint('NEW LOCALE = $newLocale');

    emit(
      LocaleState(newLocale),
    );

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'locale',
      newLocale,
    );
  }
}