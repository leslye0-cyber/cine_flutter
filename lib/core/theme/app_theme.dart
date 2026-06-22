import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // ── PALETTE ─────────────────────────────────────────────
  static const Color primary = Color(0xFF4FC3F7);
  static const Color secondary = Color(0xFF81D4FA);

  static const Color darkBg = Color(0xFF0B0B0B);
  static const Color darkCard = Color(0xFF1A1A1A);

  static const Color lightBg = Color(0xFFFAFAFA);
  static const Color lightCard = Color(0xFFFFFFFF);

  // ── DARK THEME ─────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: darkBg,

    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: darkCard,
      background: darkBg,
    ),

    textTheme: ThemeData.dark().textTheme,

    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF111111),
      selectedItemColor: primary,
      unselectedItemColor: Color(0xFF666666),
    ),

    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
    ),
  );

  // ── LIGHT THEME ────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: lightBg,

    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: lightCard,
      background: lightBg,
    ),

    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: const Color(0xFF1A1A1A),
      displayColor: const Color(0xFF1A1A1A),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: lightBg,
      foregroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      centerTitle: true,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: Color(0xFFAAAAAA),
    ),

    cardTheme: CardThemeData(
      color: lightCard,
      elevation: 1,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
    ),
  );
}