import 'package:flutter/material.dart';

class ThemeConfig {
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2563EB),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDEEAFF),
    onPrimaryContainer: Color(0xFF1E40AF),
    secondary: Color(0xFF059669),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD1FAE5),
    onSecondaryContainer: Color(0xFF047857),
    error: Color(0xFFDC2626),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFFB91C1C),
    background: Color(0xFFFAFAFA),
    onBackground: Color(0xFF111827),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF111827),
    surfaceVariant: Color(0xFFF3F4F6),
    onSurfaceVariant: Color(0xFF4B5563),
    outline: Color(0xFFD1D5DB),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF3B82F6),
    onPrimary: Color(0xFF1E293B),
    primaryContainer: Color(0xFF1E40AF),
    onPrimaryContainer: Color(0xFFDEEAFF),
    secondary: Color(0xFF10B981),
    onSecondary: Color(0xFF1F2937),
    secondaryContainer: Color(0xFF047857),
    onSecondaryContainer: Color(0xFFD1FAE5),
    error: Color(0xFFEF4444),
    onError: Color(0xFF1F2937),
    errorContainer: Color(0xFFB91C1C),
    onErrorContainer: Color(0xFFFEE2E2),
    background: Color(0xFF0F172A),
    onBackground: Color(0xFFF1F5F9),
    surface: Color(0xFF1E293B),
    onSurface: Color(0xFFF1F5F9),
    surfaceVariant: Color(0xFF334155),
    onSurfaceVariant: Color(0xFFCBD5E1),
    outline: Color(0xFF475569),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      cardTheme: CardTheme(
        color: lightColorScheme.surface,
        elevation: 2,
        shadowColor: lightColorScheme.shadow.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      cardTheme: CardTheme(
        color: darkColorScheme.surface,
        elevation: 4,
        shadowColor: darkColorScheme.shadow.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
