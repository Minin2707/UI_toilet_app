import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import 'router/app_router.dart';

class ToiletMapApp extends StatelessWidget {
  const ToiletMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.instance.appName,

      debugShowCheckedModeBanner: false,

      routerConfig: appRouter,

      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
    );
  }
}