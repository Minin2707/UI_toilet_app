import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/auth/token_storage.dart';

import '../../features/toilets/data/repositories/toilet_repository.dart';

import '../../features/toilets/presentation/bloc/toilet_bloc.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';

import '../../features/toilets/presentation/screens/toilet_map_screen.dart';



final GoRouter appRouter = GoRouter(

  initialLocation: '/auth',

  redirect: (context, state) async {

    final token =
        await TokenStorage().getToken();

    final loggedIn =
        token != null &&
        token.isNotEmpty;

    final goingToAuth =
        state.fullPath == '/auth';

    if (!loggedIn && !goingToAuth) {

      return '/auth';
    }

    if (loggedIn && goingToAuth) {

      return '/map';
    }

    return null;
  },

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

          child:
              const ToiletMapScreen(),
        );
      },
    ),
  ],
);