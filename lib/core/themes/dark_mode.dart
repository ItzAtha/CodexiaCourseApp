import 'package:flutter/material.dart';

import '../app_constants.dart' show AppColors, AppSizes;

class DarkMode {
  static ThemeData initialize() {
    return ThemeData(
      useMaterial3: true,
      canvasColor: AppColors.bgDark,
      scaffoldBackgroundColor: AppColors.bgDark,
      dividerColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.iconDark),
      radioTheme: const RadioThemeData(fillColor: WidgetStatePropertyAll(Color(0x80F5F6FA))),
      textTheme: (() {
        final textBase = Typography(platform: TargetPlatform.android).black.apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.textDark,
        );

        return textBase.copyWith(
          displaySmall: textBase.displaySmall?.copyWith(fontSize: AppSizes.xxlTextSize, fontWeight: FontWeight.bold),
          titleSmall: textBase.titleSmall?.copyWith(fontSize: AppSizes.mlTextSize, fontWeight: FontWeight.bold),
          titleMedium: textBase.titleMedium?.copyWith(fontSize: AppSizes.lTextSize, fontWeight: FontWeight.bold),
          titleLarge: textBase.titleLarge?.copyWith(fontSize: AppSizes.xlTextSize, fontWeight: FontWeight.bold),
          labelLarge: textBase.labelLarge?.copyWith(fontSize: AppSizes.mTextSize, fontWeight: FontWeight.normal),
          labelMedium: textBase.labelMedium?.copyWith(fontSize: AppSizes.smTextSize, fontWeight: FontWeight.normal),
          labelSmall: textBase.labelSmall?.copyWith(fontSize: AppSizes.sTextSize, fontWeight: FontWeight.normal),
        );
      }()),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF00CEC9),
        selectionColor: Color(0x8000CEC9),
        selectionHandleColor: Color(0xFF00CEC9),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(200.0, 40.0)),
          backgroundColor: const WidgetStatePropertyAll(Color(0xFF0984E3)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(180.0, 40.0)),
          overlayColor: const WidgetStatePropertyAll(Color(0x1A00CEC9)),
          side: const WidgetStatePropertyAll(BorderSide(color: Color(0xFF00CEC9))),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: Color(0xCCF5F6FA)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x8000CEC9), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00CEC9), width: 1.5),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: Color(0xFF00CEC9), width: 1.5),
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF00CEC9);
          }
          return null;
        }),
      ),
      cardTheme: CardThemeData(
        elevation: 4.0,
        color: const Color(0xFF28282B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(8.0),
        backgroundColor: const WidgetStatePropertyAll(Color(0xFF28282B)),
        hintStyle: const WidgetStatePropertyAll(TextStyle(color: Color(0xFFF5F6FA))),
        textStyle: const WidgetStatePropertyAll(TextStyle(color: Color(0xFFF5F6FA))),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(16.0),
          backgroundColor: const WidgetStatePropertyAll(Color(0xFF28282B)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ),
      chipTheme: const ChipThemeData(
        elevation: 4.0,
        selectedColor: Color(0xFF00CEC9),
        backgroundColor: Color(0x8000CEC9),
        checkmarkColor: Color(0xFFFCFBFB),
        side: BorderSide(color: Color(0xFF006462), width: 1.5),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 12.0,
        showDragHandle: true,
        modalBackgroundColor: Color(0xFF28282B),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(
            backgroundColor: Color(0xFF212121),
          ),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(
            backgroundColor: Color(0xFF212121),
          ),
        },
      ),
    );
  }
}
