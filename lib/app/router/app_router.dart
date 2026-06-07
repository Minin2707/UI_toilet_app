import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';

import '../../features/toilets/data/repositories/toilet_repository.dart';

import '../../features/toilets/presentation/bloc/toilet_bloc.dart';

import '../../features/toilets/presentation/screens/toilet_map_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/user_messages/presentation/screens/user_message_screen.dart';

final GoRouter appRouter = GoRouter(

  initialLocation: '/',

  routes: [

    GoRoute(

      path: '/',

      builder: (context, state) =>

          const SplashScreen(),
    ),

    GoRoute(

      path: '/onboarding',

      builder: (
        context,
        state,
      ) {

        return const OnboardingScreen();
      },
    ),

    GoRoute(
      path: '/feedback',
      builder: (context, state) {
        return const UserMessageScreen();
      },
    ),

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