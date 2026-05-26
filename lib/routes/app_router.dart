import 'package:animations/animations.dart';
import 'package:codexia_course_learning/features/auth/auth_router.dart';
import 'package:codexia_course_learning/features/course/foundation/python/python_course_router.dart';
import 'package:codexia_course_learning/features/home/dashboard_page.dart';
import 'package:codexia_course_learning/features/home/views/community_page.dart';
import 'package:codexia_course_learning/features/home/views/course_page.dart';
import 'package:codexia_course_learning/features/home/views/home_page.dart';
import 'package:codexia_course_learning/features/home/views/setting_page.dart';
import 'package:codexia_course_learning/features/legal/views/privacy_policy_page.dart';
import 'package:codexia_course_learning/features/legal/views/terms_of_service_page.dart';
import 'package:codexia_course_learning/routes/go_router_refresh_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_constants.dart' show AppRoutes;
import '../features/chat/aibot/views/ai_chat_bot_page.dart';
import '../features/profile/view/user_profile.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.authRoute.path,
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      final User? user = FirebaseAuth.instance.currentUser;
      final isAuthenticated = user != null;

      final isOnAuthPath = state.uri.path.startsWith(AppRoutes.authRoute.path);
      final isOnTermsPath =
          state.uri.path.startsWith(AppRoutes.tosRoute.path) ||
          state.uri.path.startsWith(AppRoutes.privacyRoute.path);

      if (!isAuthenticated && !(isOnAuthPath || isOnTermsPath)) {
        return AppRoutes.authRoute.path;
      }

      if (isAuthenticated && isOnAuthPath) {
        return AppRoutes.homeRoute.path;
      }
      return null;
    },
    routes: <RouteBase>[
      StatefulShellRoute(
        builder: (context, state, navigationShell) {
          return DashboardPage(navigationShell: navigationShell);
        },
        navigatorContainerBuilder: (context, navigationShell, children) {
          return PageTransitionSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                FadeThroughTransition(
                  fillColor: Colors.transparent,
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                ),
            child: children[navigationShell.currentIndex],
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.homeRoute.path,
                name: AppRoutes.homeRoute.name,
                builder: (context, state) {
                  return HomePage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.courseRoute.path,
                name: AppRoutes.courseRoute.name,
                builder: (context, state) {
                  return CoursePage();
                },
                routes: <RouteBase>[PythonCourseRouter.initialize()],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.communityRoute.path,
                name: AppRoutes.communityRoute.name,
                builder: (context, state) {
                  return CommunityPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.settingsRoute.path,
                name: AppRoutes.settingsRoute.name,
                builder: (context, state) {
                  return SettingPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: AppRoutes.editProfileRoute.path,
                    name: AppRoutes.editProfileRoute.name,
                    builder: (context, state) {
                      return const UserProfilePage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.chatBotRoute.path,
        name: AppRoutes.chatBotRoute.name,
        builder: (context, state) {
          return const AIChatBotPage();
        },
      ),
      GoRoute(
        path: AppRoutes.tosRoute.path,
        name: AppRoutes.tosRoute.name,
        builder: (context, state) {
          return const TermsOfServicePage();
        },
      ),
      GoRoute(
        path: AppRoutes.privacyRoute.path,
        name: AppRoutes.privacyRoute.name,
        builder: (context, state) {
          return const PrivacyPolicyPage();
        },
      ),

      AuthRouter.initialize(),
    ],
  );
}
