import 'package:flutter/material.dart';

class DrummieTheme {
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  static const Color accent = Color(0xFF00E5FF);
  static const Color accentDim = Color(0xFF004D54);
  static const Color stepActive = Color(0xFFFF6B00);
  static const Color stepInactive = Color(0xFF3A3A3A);
  static const Color playhead = Color(0xFF00FF88);
  static const Color textPrimary = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFF808080);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          secondary: stepActive,
          surface: surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          elevation: 0,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: accent,
          inactiveTrackColor: surfaceLight,
          thumbColor: accent,
          overlayColor: accent.withValues(alpha: 0.2),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textPrimary),
          labelMedium: TextStyle(
            color: textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
