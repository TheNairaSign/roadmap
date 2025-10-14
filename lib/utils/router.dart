import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roadmap/models/roadmap_model.dart';
import 'package:roadmap/screens/auth/auth_wrapper.dart';
import 'package:roadmap/screens/auth/bloc/auth_bloc.dart';
import 'package:roadmap/screens/auth/login_screen.dart';
import 'package:roadmap/screens/auth/signup_screen.dart';
import 'package:roadmap/screens/roadmap/create_roadmap_screen.dart';
import 'package:roadmap/screens/roadmap/roadmap_detail_screen.dart';
import 'package:roadmap/screens/roadmap/roadmap_list_screen.dart';
import 'package:roadmap/screens/roadmap/template_selection_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const AuthWrapper(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/roadmaps',
        builder: (BuildContext context, GoRouterState state) => const RoadmapListScreen(),
        routes: [
          GoRoute(
            path: ':roadmapId',
            builder: (BuildContext context, GoRouterState state) {
              final roadmap = state.extra as RoadmapModel?;
              if (roadmap != null) {
                return RoadmapDetailScreen(roadmap: roadmap);
              } else {
                // Handle case where roadmap is not passed, maybe fetch it?
                // For now, redirecting back or showing an error.
                return const Text('Error: Roadmap not found.');
              }
            },
          ),
        ],
      ),
      GoRoute(
        path: '/create-roadmap',
        builder: (BuildContext context, GoRouterState state) => const CreateRoadmapScreen(),
      ),
      GoRoute(
        path: '/templates',
        builder: (BuildContext context, GoRouterState state) => const TemplateSelectionScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      print('Login status: $loggedIn');
      final bool loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (!loggedIn) {
        print('User is not logged in, redirecting to login');
        return loggingIn ? null : '/login';
      }

      if (state.matchedLocation == '/') {
        print('User is logged in, redirecting to roadmaps');
        return '/roadmaps';
      }

      // if (loggedIn) {
      //   print('User is logged in, redirecting to roadmaps');
      //   return '/roadmaps';
      // }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
