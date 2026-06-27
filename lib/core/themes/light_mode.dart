import 'package:flutter/material.dart';

import '../app_constants.dart' show AppColors, AppSizes;

class LightMode {
  static ThemeData initialize() {
    return ThemeData(
      useMaterial3: true,
      canvasColor: AppColors.bgLight,
      scaffoldBackgroundColor: AppColors.bgLight,
      dividerColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.iconLight),
      radioTheme: const RadioThemeData(fillColor: WidgetStatePropertyAll(Colors.grey)),
      textTheme: (() {
        final textBase = Typography(
          platform: TargetPlatform.android,
        ).black.apply(bodyColor: AppColors.textLight, displayColor: AppColors.textLight);

        return textBase.copyWith(
          displaySmall: textBase.displaySmall?.copyWith(
            fontSize: AppSizes.xxlTextSize,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: textBase.titleSmall?.copyWith(
            fontSize: AppSizes.mlTextSize,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: textBase.titleMedium?.copyWith(
            fontSize: AppSizes.lTextSize,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: textBase.titleLarge?.copyWith(
            fontSize: AppSizes.xlTextSize,
            fontWeight: FontWeight.bold,
          ),
          labelLarge: textBase.labelLarge?.copyWith(
            fontSize: AppSizes.mTextSize,
            fontWeight: FontWeight.normal,
          ),
          labelMedium: textBase.labelMedium?.copyWith(
            fontSize: AppSizes.smTextSize,
            fontWeight: FontWeight.normal,
          ),
          labelSmall: textBase.labelSmall?.copyWith(
            fontSize: AppSizes.sTextSize,
            fontWeight: FontWeight.normal,
          ),
        );
      }()),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.secondary,
        selectionColor: AppColors.secondary.withValues(alpha: 0.3),
        selectionHandleColor: AppColors.secondary,
      ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(200.0, 40.0)),
          backgroundColor: WidgetStatePropertyAll(AppColors.primary),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(180.0, 40.0)),
          overlayColor: WidgetStatePropertyAll(AppColors.secondary.withValues(alpha: 0.1)),
          side: const WidgetStatePropertyAll(BorderSide(color: AppColors.secondary)),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        border: const OutlineInputBorder(),
        hintStyle: TextStyle(color: Colors.grey.shade700),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x8000CEC9), width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xCC00CEC9), width: 1.5),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: Color(0xCC00CEC9), width: 1.5),
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xCC00CEC9);
          }
          return null;
        }),
      ),
      cardTheme: const CardThemeData(
        elevation: 2.0,
        color: AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(8.0),
        backgroundColor: const WidgetStatePropertyAll(AppColors.cardLight),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(color: AppColors.textLight.withValues(alpha: 0.8)),
        ),
        textStyle: const WidgetStatePropertyAll(TextStyle(color: AppColors.textLight)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(8.0),
          backgroundColor: WidgetStatePropertyAll(AppColors.cardLight),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        elevation: 4.0,
        selectedColor: AppColors.secondary,
        backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
        checkmarkColor: AppColors.textDark,
        side: const BorderSide(color: Color(0xFF006462), width: 1.5),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 8.0,
        showDragHandle: true,
        modalBackgroundColor: Color(0xFFFCFBFB),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(
            backgroundColor: Color(0xFFF5F6FA),
          ),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(
            backgroundColor: Color(0xFFF5F6FA),
          ),
        },
      ),
    );
  }
}
