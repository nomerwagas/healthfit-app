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

  // ── Celestial Cyan palette (New Dark Mode) ────────────────────────────────
  static const cyan = Color(0xFF00D1FF);
  static const cyanLight = Color(0xFF66E3FF);
  static const cyanDark = Color(0xFF009CBF);
  static const cyanDeep = Color(0xFF006B82);

  // ── Celestial Slate palette (New Dark Mode Backgrounds) ───────────────────
  static const slateBase = Color(0xFF07121A);
  static const slateSurface = Color(0xFF0E1A24);
  static const slateSurfacePlus = Color(0xFF152330);
  static const slateSurfaceHighlight = Color(0xFF203244);

  // ── Celestial Borders (New Dark Mode) ─────────────────────────────────────
  static const borderCyanDark = Color(0x3300D1FF); // cyan 20% — dark mode
  static const borderCyan60 = Color(0x9900D1FF); // cyan 60% — emphasis
  static const borderCyanLight = Color(0x4000D1FF); // cyan 25% — light mode
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
        primary: AppColors.cyanDark,
        onPrimary: AppColors.white,
        secondary: AppColors.cyan,
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
        iconTheme: IconThemeData(color: AppColors.cyanDark, size: 20),
      ),

      // ── Bottom Navigation ───────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.borderCyanLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? AppColors.cyanDark : AppColors.textDarkHint,
            fontSize: 9,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            letterSpacing: 1,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.cyanDark : AppColors.textDarkHint,
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
          side: const BorderSide(color: AppColors.borderCyanLight, width: 0.8),
        ),
      ),

      // ── Input ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.offWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(
            color: AppColors.cyanDark,
            fontSize: 13,
            fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: AppColors.textDarkHint, fontSize: 13),
        prefixIconColor: AppColors.cyanDark,
        suffixIconColor: AppColors.textDarkHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.borderCyanLight, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.borderCyanLight, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.cyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 0.8),
        ),
      ),

      // ── Filled Button ───────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.cyanDark,
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
          foregroundColor: AppColors.cyanDark,
          side: const BorderSide(color: AppColors.cyan, width: 0.8),
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
          foregroundColor: AppColors.cyanDark,
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
                ? AppColors.cyan
                : AppColors.lightSurf2),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
          color: AppColors.borderCyanLight, thickness: 0.8),

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
            color: AppColors.cyanDark,
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
          side: const BorderSide(color: AppColors.borderCyanLight),
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
  // DARK THEME — Slate + Cyan
  // ══════════════════════════════════════════════════════════════════════════
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.slateBase,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.cyan,
        onPrimary: AppColors.slateBase,
        secondary: AppColors.cyanLight,
        onSecondary: AppColors.slateBase,
        surface: AppColors.slateSurface,
        onSurface: AppColors.textLight,
        surfaceContainer: AppColors.slateSurfacePlus,
        error: Color(0xFFFF5F5F),
        onError: AppColors.white,
      ),

      // ── AppBar ─────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.slateBase,
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
        iconTheme: IconThemeData(color: AppColors.cyan, size: 20),
      ),

      // ── Bottom Navigation ───────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.slateBase,
        indicatorColor: AppColors.white07,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? AppColors.cyan : AppColors.textLightHint,
            fontSize: 9,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            letterSpacing: 1,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.cyan : AppColors.textLightHint,
            size: 22,
          );
        }),
      ),

      // ── Card ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.slateSurfacePlus,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.borderCyanDark, width: 0.5),
        ),
      ),

      // ── Input ──────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.slateSurfacePlus,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(
            color: AppColors.cyan, fontSize: 13, fontWeight: FontWeight.w500),
        hintStyle:
            const TextStyle(color: AppColors.textLightHint, fontSize: 13),
        prefixIconColor: AppColors.cyan,
        suffixIconColor: AppColors.textLightHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.borderCyanDark, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.borderCyanDark, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.cyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF5F5F), width: 0.5),
        ),
      ),

      // ── Filled Button ───────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.cyan,
          foregroundColor: AppColors.slateBase,
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
          foregroundColor: AppColors.cyan,
          side: const BorderSide(color: AppColors.borderCyan60, width: 0.5),
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
          foregroundColor: AppColors.cyan,
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Switch ─────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.slateBase
                : AppColors.textLightHint),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.cyan
                : AppColors.white15),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Divider ─────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
          color: AppColors.borderCyanDark, thickness: 0.5),

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
            color: AppColors.cyan,
            fontWeight: FontWeight.w700,
            letterSpacing: 1),
        labelMedium: TextStyle(color: AppColors.textLightMuted),
        labelSmall:
            TextStyle(color: AppColors.textLightHint, letterSpacing: 0.8),
      ),

      // ── Snackbar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.slateSurfacePlus,
        contentTextStyle:
            const TextStyle(color: AppColors.textLight, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.borderCyanDark),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.slateSurfacePlus,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderCyanDark),
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
