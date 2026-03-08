import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/opening_page.dart';
import '../home/views/home_page.dart';

class AuthenticationGate extends StatelessWidget {
  final String _title;

  const AuthenticationGate({super.key, required String title}) : _title = title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          }

          return const OpeningPage();
        },
      ),
    );
  }
}
