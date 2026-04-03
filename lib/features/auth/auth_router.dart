import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'views/opening_page.dart';
import '../home/dashboard_page.dart';

class AuthenticationGate extends ConsumerWidget {
  final String _title;

  const AuthenticationGate({super.key, required String title}) : _title = title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authUserProvider, (previous, next) {
      next.when(
        data: (data) {
          print("Successfully loaded profile: ${data.username}");
        },
        error: (error, stackTrace) {
          print("Error loading profile: $error");
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
          print("Loading profile...");
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

          return OpeningPage(title: _title);
        },
      ),
    );
  }
}
