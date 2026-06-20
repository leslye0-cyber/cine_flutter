import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryPink = Color(0xFFE91E8C);
  static const Color pinkLight = Color(0xFFFF4DB8);
  static const Color bgBlack = Color(0xFF0A0A0A);
  static const Color bgCard = Color(0xFF1A1A1A);
  static const Color bgCard2 = Color(0xFF232323);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color borderColor = Color(0xFF2A2A2A);

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgBlack,
    colorScheme: const ColorScheme.dark(
      primary: primaryPink,
      secondary: pinkLight,
      surface: bgCard,
      background: bgBlack,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A0A0A),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF111111),
      selectedItemColor: primaryPink,
      unselectedItemColor: Color(0xFF666666),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(fontSize: 10),
    ),
    // ✅ CardThemeData au lieu de CardTheme
    cardTheme: CardThemeData(
      color: bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryPink,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: bgCard,
      border: InputBorder.none,
      hintStyle: TextStyle(color: Color(0xFF666666)),
      labelStyle: TextStyle(color: Colors.white),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF1A1A1A),
      thickness: 0.5,
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: Color(0xFF111111),
      textColor: Colors.white,
      iconColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? primaryPink
            : Colors.grey,
      ),
      trackColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? primaryPink.withOpacity(0.5)
            : Colors.grey.withOpacity(0.3),
      ),
    ),
    // ✅ DialogThemeData au lieu de DialogTheme
    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF1A1A1A),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 14,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF1A1A1A),
      contentTextStyle: TextStyle(color: Colors.white),
      actionTextColor: primaryPink,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1A1A1A),
      selectedColor: primaryPink,
      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
      side: const BorderSide(color: Color(0xFF2A2A2A)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryPink,
    ),
  );
}