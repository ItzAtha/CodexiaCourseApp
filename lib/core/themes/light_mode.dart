import 'package:flutter/material.dart';

class LightMode {
  static ThemeData initialize() {
    return ThemeData(
      useMaterial3: true,
      canvasColor: Color(0xFFF5F6FA),
      scaffoldBackgroundColor: Color(0xFFF5F6FA),
      dividerColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.grey.shade700),
      radioTheme: RadioThemeData(fillColor: WidgetStatePropertyAll(Colors.grey)),
      textTheme: TextTheme(
        labelLarge: TextStyle(color: Colors.grey.shade800),
        labelMedium: TextStyle(color: Colors.grey.shade800),
        labelSmall: TextStyle(color: Colors.grey.shade800),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xCC00CEC9),
        selectionColor: Color(0xCC00CEC9),
        selectionHandleColor: Color(0xCC00CEC9),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(200.0, 40.0)),
          backgroundColor: WidgetStatePropertyAll(Color(0xCC0984E3)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(180.0, 40.0)),
          overlayColor: WidgetStatePropertyAll(Color(0x0D00CEC9)),
          side: WidgetStatePropertyAll(BorderSide(color: Color(0xCC00CEC9))),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: Colors.grey.shade700),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x8000CEC9), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xCC00CEC9), width: 1.5),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: Color(0xCC00CEC9), width: 1.5),
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xCC00CEC9);
          }
          return null;
        }),
      ),
      cardTheme: CardThemeData(
        elevation: 2.0,
        color: Color(0xFFFCFBFB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStatePropertyAll(4.0),
        backgroundColor: WidgetStatePropertyAll(Color(0xFFFCFBFB)),
        hintStyle: WidgetStatePropertyAll(TextStyle(color: Colors.grey.shade700)),
        textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.grey.shade700)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(8.0),
          backgroundColor: WidgetStatePropertyAll(Color(0xFFFCFBFB)),
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
        elevation: 8.0,
        showDragHandle: true,
        modalBackgroundColor: Color(0xFFFCFBFB),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
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
