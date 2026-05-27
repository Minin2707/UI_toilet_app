import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';

import 'core/config/app_config.dart';
import 'core/config/environment.dart';

import 'core/localization/locale_cubit.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(
    Environment.dev,
  );

  runApp(

    BlocProvider(

      create: (_) => LocaleCubit(),

      child: const ToiletMapApp(),
    ),
  );
}