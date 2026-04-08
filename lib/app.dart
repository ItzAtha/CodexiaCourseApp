import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:codexia_course_learning/core/themes/light_mode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'core/themes/dark_mode.dart';
import 'features/auth/auth_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required AdaptiveThemeMode? themeMode}) : _themeMode = themeMode;

  final AdaptiveThemeMode? _themeMode;

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: ToastificationConfig(maxToastLimit: 1),
      child: AdaptiveTheme(
        debugShowFloatingThemeButton: true,
        light: LightMode.initialize(),
        dark: DarkMode.initialize(),
        initial: widget._themeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          title: 'Codexia Learning Course',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: theme,
          darkTheme: darkTheme,
          home: AuthenticationGate(),
        ),
      ),
    );
  }
}
