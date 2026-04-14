import 'package:animations/animations.dart';
import 'package:codexia_course_learning/features/auth/auth_router.dart';
import 'package:codexia_course_learning/features/course/foundation/python/python_course_router.dart';
import 'package:codexia_course_learning/features/home/dashboard_page.dart';
import 'package:codexia_course_learning/features/home/views/ai_chat_bot_page.dart';
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

import '../features/profile/view/user_profile.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      final User? user = FirebaseAuth.instance.currentUser;
      final isAuthenticated = user != null;

      final isOnAuthPath = state.uri.path.startsWith('/auth');
      final isOnTermsPath =
          state.uri.path.startsWith('/term-of-service') ||
          state.uri.path.startsWith('/privacy-policy');

      if (!isAuthenticated && !(isOnAuthPath || isOnTermsPath)) {
        return '/auth';
      }

      if (isAuthenticated && isOnAuthPath) {
        return '/home';
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
                path: '/home',
                name: 'home',
                builder: (context, state) {
                  return HomePage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/course',
                name: 'course',
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
                path: '/community',
                name: 'community',
                builder: (context, state) {
                  return CommunityPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) {
                  return SettingPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'user-profile',
                    name: 'edit-profile',
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
        path: '/ai-chat-bot',
        name: 'ai-chat',
        builder: (context, state) {
          return const AIChatBotPage();
        },
      ),
      GoRoute(
        path: '/term-of-service',
        name: 'tos',
        builder: (context, state) {
          return const TermsOfServicePage();
        },
      ),
      GoRoute(
        path: '/privacy-policy',
        name: 'privacy-policy',
        builder: (context, state) {
          return const PrivacyPolicyPage();
        },
      ),

      AuthRouter.initialize(),
    ],
  );
}
