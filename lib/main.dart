import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_services.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

import 'app.dart';
import 'manager/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await dotenv.load(fileName: '.env');
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const SharedPreferencesAsyncAndroidOptions options =
  SharedPreferencesAsyncAndroidOptions(
    backend: SharedPreferencesAndroidBackendLibrary.SharedPreferences,
    originalSharedPreferencesOptions: AndroidSharedPreferencesStoreOptions(
      fileName: 'auth_prefs',
    ),
  );

  SharedPreferencesAsync sharedPreferences = SharedPreferencesAsync(options: options);

  final User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final bool hasEmailProvider = currentUser.providerData.any(
          (userInfo) => userInfo.providerId == 'password',
    );

    if (hasEmailProvider) {
      print('User is signed in with Email/Password provider.');

      bool isRememberMe = await sharedPreferences.getBool('rememberMe') ?? false;
      if (isRememberMe) {
        bool successLogout = await AuthService().signOut();
        if (successLogout) {
          print('Successfully signed out user from email providers.');
        } else {
          print('No user was signed in or an error occurred during sign-out.');
        }
      }
    } else {
      print('User is signed in with a provider other than Email/Password.');
    }
  } else {
    print('No user is currently signed in.');
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: MyApp(themeMode: savedThemeMode),
    ),
  );
}
