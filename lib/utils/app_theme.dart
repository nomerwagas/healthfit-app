// lib/utils/app_theme.dart
// Light mode: White + Gold | Dark mode: Black + Gold
// All text is high-contrast in both modes

import 'package:flutter/material.dart';

class AppColors {
  // ── Gold palette ──────────────────────────────────────────────────────────
  static const gold = Color(0xFFC9A84C);
  static const goldLight = Color(0xFFF5D78E);
  static const goldDark = Color(0xFF8B6914);
  static const goldDeep = Color(0xFF6B500F);

  // ── Dark mode colors ──────────────────────────────────────────────────────
  static const black = Color(0xFF0A0A0A);
  static const black2 = Color(0xFF111111);
  static const black3 = Color(0xFF1A1A1A);
  static const black4 = Color(0xFF222222);

  // ── Light mode colors ─────────────────────────────────────────────────────
  static const white = Color(0xFFFFFFFF);
  static const offWhite = Color(0xFFFAF9F6);
  static const lightSurf = Color(0xFFF2EFE8);
  static const lightSurf2 = Color(0xFFE8E3D8);

  // ── Text colors — light mode ──────────────────────────────────────────────
  static const textDark = Color(0xFF0D0D0D); // primary text on white bg
  static const textDarkMuted = Color(0xFF555555); // secondary text on white bg
  static const textDarkHint = Color(0xFF888888); // hint text on white bg

  // ── Text colors — dark mode ───────────────────────────────────────────────
  static const textLight = Color(0xFFFFFFFF); // primary text on black bg
  static const textLightMuted = Color(0xFFCCCCCC); // secondary text on black bg
  static const textLightHint = Color(0xFF888888); // hint text on black bg

  // ── Borders ───────────────────────────────────────────────────────────────
  static const borderGoldLight = Color(0x40C9A84C); // gold 25% — light mode
  static const borderGoldDark = Color(0x33C9A84C); // gold 20% — dark mode
  static const borderGold60 = Color(0x99C9A84C); // gold 60% — emphasis

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFF57F17);

  // ── Transparent helpers ───────────────────────────────────────────────────
  static const white07 = Color(0x12FFFFFF);
  static const white15 = Color(0x26FFFFFF);
  static const white50 = Color(0x80FFFFFF);
  static const white85 = Color(0xD9FFFFFF);
  static const black07 = Color(0x12000000);
  static const black15 = Color(0x26000000);
}

class AppTheme {
  // ══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME — White + Gold
  // ══════════════════════════════════════════════════════════════════════════
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.offWhite,

      colorScheme: const ColorScheme.light(
        primary: AppColors.goldDark,
        onPrimary: AppColors.white,
        secondary: AppColors.gold,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.textDark,
        surfaceContainer: AppColors.lightSurf,
        error: AppColors.error,
        onError: AppColors.white,
      ),

      // ── AppBar ─────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: AppColors.goldDark, size: 20),
      ),

      // ── Bottom Navigation ───────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.borderGoldLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? AppColors.goldDark : AppColors.textDarkHint,
            fontSize: 9,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            letterSpacing: 1,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.goldDark : AppColors.textDarkHint,
            size: 22,
          );
        }),
      ),

      // ── Card ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.borderGoldLight, width: 0.8),
        ),
      ),

      // ── Input ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.offWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(
            color: AppColors.goldDark,
            fontSize: 13,
            fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: AppColors.textDarkHint, fontSize: 13),
        prefixIconColor: AppColors.goldDark,
        suffixIconColor: AppColors.textDarkHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.borderGoldLight, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.borderGoldLight, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 0.8),
        ),
      ),

      // ── Filled Button ───────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.goldDark,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.goldDark,
          side: const BorderSide(color: AppColors.gold, width: 0.8),
          padding: const EdgeInsets.symmetric(vertical: 13),
          textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // ── Text Button ─────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.goldDark,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Switch ─────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.white
                : AppColors.textDarkHint),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.gold
                : AppColors.lightSurf2),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
          color: AppColors.borderGoldLight, thickness: 0.8),

      // ── Text ────────────────────────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w800),
        displayMedium:
            TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w800),
        headlineLarge:
            TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700),
        headlineMedium:
            TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700),
        headlineSmall:
            TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700),
        titleLarge:
            TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700),
        titleMedium:
            TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
        titleSmall:
            TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.textDark),
        bodyMedium: TextStyle(color: AppColors.textDark),
        bodySmall: TextStyle(color: AppColors.textDarkMuted),
        labelLarge: TextStyle(
            color: AppColors.goldDark,
            fontWeight: FontWeight.w700,
            letterSpacing: 1),
        labelMedium: TextStyle(color: AppColors.textDarkMuted),
        labelSmall:
            TextStyle(color: AppColors.textDarkHint, letterSpacing: 0.8),
      ),

      // ── Snackbar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textDark,
        contentTextStyle: const TextStyle(color: AppColors.white, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderGoldLight),
        ),
        titleTextStyle: const TextStyle(
            color: AppColors.textDark,
            fontSize: 17,
            fontWeight: FontWeight.w700),
        contentTextStyle:
            const TextStyle(color: AppColors.textDarkMuted, fontSize: 14),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DARK THEME — Black + Gold
  // ══════════════════════════════════════════════════════════════════════════
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        onPrimary: AppColors.black,
        secondary: AppColors.goldLight,
        onSecondary: AppColors.black,
        surface: AppColors.black2,
        onSurface: AppColors.textLight,
        surfaceContainer: AppColors.black3,
        error: Color(0xFFFF5F5F),
        onError: AppColors.white,
      ),

      // ── AppBar ─────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: AppColors.gold, size: 20),
      ),

      // ── Bottom Navigation ───────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.black,
        indicatorColor: AppColors.white07,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? AppColors.gold : AppColors.textLightHint,
            fontSize: 9,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            letterSpacing: 1,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.gold : AppColors.textLightHint,
            size: 22,
          );
        }),
      ),

      // ── Card ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.black3,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.borderGoldDark, width: 0.5),
        ),
      ),

      // ── Input ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.black3,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(
            color: AppColors.gold, fontSize: 13, fontWeight: FontWeight.w500),
        hintStyle:
            const TextStyle(color: AppColors.textLightHint, fontSize: 13),
        prefixIconColor: AppColors.gold,
        suffixIconColor: AppColors.textLightHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.borderGoldDark, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.borderGoldDark, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF5F5F), width: 0.5),
        ),
      ),

      // ── Filled Button ───────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.borderGold60, width: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 13),
          textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // ── Text Button ─────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Switch ─────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.black
                : AppColors.textLightHint),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.gold
                : AppColors.white15),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
          color: AppColors.borderGoldDark, thickness: 0.5),

      // ── Text ────────────────────────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w800),
        displayMedium:
            TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w800),
        headlineLarge:
            TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w700),
        headlineMedium:
            TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w700),
        headlineSmall:
            TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w700),
        titleLarge:
            TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w700),
        titleMedium:
            TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600),
        titleSmall:
            TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.textLightMuted),
        bodyMedium: TextStyle(color: AppColors.textLightMuted),
        bodySmall: TextStyle(color: AppColors.textLightHint),
        labelLarge: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.w700,
            letterSpacing: 1),
        labelMedium: TextStyle(color: AppColors.textLightMuted),
        labelSmall:
            TextStyle(color: AppColors.textLightHint, letterSpacing: 0.8),
      ),

      // ── Snackbar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.black3,
        contentTextStyle:
            const TextStyle(color: AppColors.textLight, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.borderGoldDark),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.black3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderGoldDark),
        ),
        titleTextStyle: const TextStyle(
            color: AppColors.textLight,
            fontSize: 17,
            fontWeight: FontWeight.w700),
        contentTextStyle:
            const TextStyle(color: AppColors.textLightMuted, fontSize: 14),
      ),
    );
  }
}
