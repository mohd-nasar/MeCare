import 'package:flutter/material.dart';

class AppTheme {
  // Main Colors
  static const Color primaryGreen =
  Color(0xFF0F766E);

  static const Color accentGreen =
  Color(0xFF00A67E);

  static const Color scaffoldLight =
  Color(0xFFF8FAFC);

  static const Color textDark =
  Color(0xFF111827);

  // Dark Mode Checker
  static bool isDark(
      BuildContext context) {
    return Theme.of(context)
        .brightness ==
        Brightness.dark;
  }

  // Theme-aware Colors
  static Color cardColor(
      BuildContext context) {
    return isDark(context)
        ? const Color(0xFF1E1E1E)
        : Colors.white;
  }

  static Color actionTileGreen(
      BuildContext context) {
    return isDark(context)
        ? const Color(0x00000000)
        : const Color(0xFFFFFFFF);
  }

  static Color shadowColor(
      BuildContext context) {
    return isDark(context)
        ? Colors.black26
        : Colors.black
        .withOpacity(0.04);
  }

  static Color textColor(
      BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyLarge
        ?.color ??
        Colors.black;
  }
}