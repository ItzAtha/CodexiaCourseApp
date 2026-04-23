import 'package:flutter/material.dart';

class DarkMode {
  static ThemeData initialize() {
    return ThemeData(
      useMaterial3: true,
      canvasColor: Color(0xFF212121),
      scaffoldBackgroundColor: Color(0xFF212121),
      dividerColor: Colors.transparent,
      iconTheme: IconThemeData(color: Color(0xCCF5F6FA)),
      radioTheme: RadioThemeData(fillColor: WidgetStatePropertyAll(Color(0x80F5F6FA))),
      textTheme: TextTheme(
        labelLarge: TextStyle(color: Color(0xFFF5F6FA)),
        labelMedium: TextStyle(color: Color(0xFFF5F6FA)),
        labelSmall: TextStyle(color: Color(0xFFF5F6FA)),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFF00CEC9),
        selectionColor: Color(0x8000CEC9),
        selectionHandleColor: Color(0xFF00CEC9),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(200.0, 40.0)),
          backgroundColor: WidgetStatePropertyAll(Color(0xFF0984E3)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(180.0, 40.0)),
          overlayColor: WidgetStatePropertyAll(Color(0x1A00CEC9)),
          side: WidgetStatePropertyAll(BorderSide(color: Color(0xFF00CEC9))),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
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
        side: BorderSide(color: Color(0xFF00CEC9), width: 1.5),
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFF00CEC9);
          }
          return null;
        }),
      ),
      cardTheme: CardThemeData(
        elevation: 4.0,
        color: Color(0xFF28282B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStatePropertyAll(8.0),
        backgroundColor: WidgetStatePropertyAll(Color(0xFF28282B)),
        hintStyle: WidgetStatePropertyAll(TextStyle(color: Color(0xFFF5F6FA))),
        textStyle: WidgetStatePropertyAll(TextStyle(color: Color(0xFFF5F6FA))),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(16.0),
          backgroundColor: WidgetStatePropertyAll(Color(0xFF28282B)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        elevation: 4.0,
        selectedColor: Color(0xFF00CEC9),
        backgroundColor: Color(0x8000CEC9),
        checkmarkColor: Color(0xFFFCFBFB),
        side: BorderSide(color: Color(0xFF006462), width: 1.5),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 12.0,
        showDragHandle: true,
        modalBackgroundColor: Color(0xFF28282B),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
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
