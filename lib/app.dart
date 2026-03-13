import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'features/auth/auth_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required AdaptiveThemeMode? themeMode})
    : _themeMode = themeMode;

  final AdaptiveThemeMode? _themeMode;

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData lightTheme;
  late ThemeData darkTheme;

  @override
  void initState() {
    super.initState();

    lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Color(0xFFF5F6FA),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(Color(0xFFFCFBFB)),
      ),
    );

    darkTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Color(0xFFF5F6FA),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(Color(0xFFFCFBFB)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: ToastificationConfig(),
      child: AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: widget._themeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          title: 'Codexia Learning Course',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: theme,
          darkTheme: darkTheme,
          home: AuthenticationGate(title: "Codexia Learning Course"),
        ),
      ),
    );
  }
}
