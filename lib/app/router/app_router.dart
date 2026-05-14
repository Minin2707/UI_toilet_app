import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/toilets/data/repositories/toilet_repository.dart';

import '../../features/toilets/presentation/bloc/toilet_bloc.dart';

import '../../features/toilets/presentation/bloc/toilet_event.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/toilets/presentation/screens/toilet_map_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/auth',

  routes: [

    GoRoute(
      path: '/auth',
      builder: (context, state) =>
          const AuthScreen(),
    ),

    GoRoute(
      path: '/map',

      builder: (context, state) {

        return BlocProvider(
          create: (_) => ToiletBloc(
            ToiletRepository(),
          ),

          child: const ToiletMapScreen(),
        );
      },
    ),
  ],
);