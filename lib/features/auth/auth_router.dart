import 'package:codexia_course_learning/features/auth/widgets/auth_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthRouter {
  AuthRouter._();

  static GoRoute initialize() {
    GoRoute authRouter = GoRoute(
      path: '/auth',
      name: 'authentication',
      builder: (context, state) {
        return AuthLandingPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          name: 'login',
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'register',
          name: 'register',
          builder: (context, state) {
            return const RegisterPage();
          },
        ),
        GoRoute(
          path: 'reset-password',
          name: 'reset-password',
          builder: (BuildContext context, GoRouterState state) {
            return const ResetPasswordPage();
          },
        ),
      ],
    );

    return authRouter;
  }
}
