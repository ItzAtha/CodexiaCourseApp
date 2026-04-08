import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import '../../core/utils/logger.dart';
import 'views/opening_page.dart';
import '../home/dashboard_page.dart';

class AuthenticationGate extends ConsumerWidget {
  const AuthenticationGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authUserProvider, (previous, next) {
      next.when(
        data: (data) {
          DebugLogger(
            message: "Successfully loaded profile: ${data.username}",
            level: LogLevel.info,
          ).log();
        },
        error: (error, stackTrace) {
          DebugLogger(
            message: "Error loading profile: $error",
            stackTrace: stackTrace,
            level: LogLevel.error,
          ).log();
          Toastification().show(
            context: context,
            title: Text("Couldn't load profile"),
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            alignment: Alignment.bottomCenter,
            autoCloseDuration: Duration(seconds: 2),
            animationDuration: Duration(milliseconds: 500),
          );
        },
        loading: () {
          DebugLogger(message: "Loading profile...", level: LogLevel.info).log();
        },
      );
    });

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const DashboardPage();
          }

          return OpeningPage();
        },
      ),
    );
  }
}
