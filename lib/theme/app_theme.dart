import 'package:flutter/material.dart';

ThemeData buildLightTheme({TextTheme? textTheme}) {
  const seedColor = Color(0xFF2BC0A5);
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFFF5F6FB),
    textTheme: textTheme ?? base.textTheme,
    // FAB rengi kartlarla aynı olsun
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: base.colorScheme.primary,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      hintStyle: base.textTheme.bodyMedium?.copyWith(
        color: Colors.grey.shade500,
      ),
    ),
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: Colors.black87,
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

ThemeData buildDarkTheme({TextTheme? textTheme}) {
  const seedColor = Color(0xFF2BC0A5);

  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    textTheme: (textTheme ?? base.textTheme).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    // FAB rengi kartlarla aynı olsun
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: base.colorScheme.primary,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: base.textTheme.bodyMedium?.copyWith(
        color: Colors.grey.shade600,
      ),
      // Kullanıcının yazdığı text'in rengi
      prefixStyle: const TextStyle(color: Colors.white),
      suffixStyle: const TextStyle(color: Colors.white),
    ),
    appBarTheme: base.appBarTheme.copyWith(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: Colors.white,
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1A1A),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        side: BorderSide(color: Color(0xFF2A2A2A), width: 1),
      ),
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: Color(0xFF1A1A1A),
      elevation: 8,
      shadowColor: Colors.black,
    ),
  );
}

// Backward compatibility
ThemeData buildAppTheme({TextTheme? textTheme}) =>
    buildLightTheme(textTheme: textTheme);
