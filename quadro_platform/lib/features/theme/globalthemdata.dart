import 'package:flutter/material.dart';

class GlobalThemData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);
  //   light theme
  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor, text);
  //  dark theme
  static ThemeData darkThemeData =
      themeData(darkColorScheme, _darkFocusColor, text);

  // function to create ThemeData
  static ThemeData themeData(
      ColorScheme colorScheme, Color focusColor, TextTheme text) {
    return ThemeData(
        useMaterial3: true,
        fontFamily: 'Madhani-Arabic',
        textTheme: text,
        colorScheme: colorScheme,
        canvasColor: colorScheme.surface,
        scaffoldBackgroundColor: colorScheme.surface,
        highlightColor: Colors.transparent,
        focusColor: focusColor);
  }

// text theme
  static final TextTheme text = TextTheme(
      displayLarge: const TextStyle().copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 35,
        color: const Color(0xff0288a6),
      ),
      headlineLarge: const TextStyle().copyWith(
        fontWeight: FontWeight.bold, // Bold font
        fontSize: 24,
      ),
      headlineMedium: const TextStyle().copyWith(
        fontWeight: FontWeight.w900, // Medium font
        fontSize: 18,
      ),
      headlineSmall: const TextStyle().copyWith(
        fontWeight: FontWeight.w500, // Medium font
        fontSize: 16,
      ));

  // color scheme for the dark mode
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xff0288a6),
    secondary: Color(0xFF05AB9F),
    surface: Color(0xFF1F1929),
    error: Colors.redAccent,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    brightness: Brightness.dark,
  );
  // color scheme for the light mode
  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xff0288a6),
    onPrimary: Colors.white,
    secondary: Color(0xFF05AB9F),
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );
}
