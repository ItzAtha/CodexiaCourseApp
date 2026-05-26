import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/widgets/auth_widget.dart';
import '../../core/app_constants.dart' show AppRoutes;

class AuthRouter {
  AuthRouter._();

  static GoRoute initialize() {
    GoRoute authRouter = GoRoute(
      path: AppRoutes.authRoute.path,
      name: AppRoutes.authRoute.name,
      builder: (context, state) {
        return AuthLandingPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.loginRoute.path,
          name: AppRoutes.loginRoute.name,
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: AppRoutes.registerRoute.path,
          name: AppRoutes.registerRoute.name,
          builder: (context, state) {
            return const RegisterPage();
          },
        ),
        GoRoute(
          path: AppRoutes.resetPassRoute.path,
          name: AppRoutes.resetPassRoute.name,
          builder: (BuildContext context, GoRouterState state) {
            return const ResetPasswordPage();
          },
        ),
      ],
    );

    return authRouter;
  }
}
