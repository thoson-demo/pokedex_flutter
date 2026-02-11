import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette: Cyberpunk / Neon Glow
  static const Color primary = Color(0xFF7C3AED); // Neon Purple
  static const Color secondary = Color(0xFFF43F5E); // Fluorescent Rose
  static const Color background = Color(0xFF0F0F23); // Deep Space Dark
  static const Color surface = Color(0xFF1E1E3F); // Lighter Dark Surface
  static const Color text = Color(0xFFE2E8F0); // Light Grey
  static const Color textDim = Color(0xFF94A3B8); // Dim Grey

  static ThemeData get lightTheme {
    // Note: We use 'lightTheme' accessor for compatibility but implement Dark Mode rules
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: text,
        onBackground: text,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: text,
              letterSpacing: 2.0,
              shadows: [Shadow(color: primary, blurRadius: 15)],
            ),
            titleLarge: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: text,
            ),
            bodyLarge: const TextStyle(fontSize: 16, color: text),
            bodyMedium: const TextStyle(fontSize: 14, color: textDim),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: text,
          letterSpacing: 1.5,
          shadows: [Shadow(color: primary, blurRadius: 10)],
        ),
        iconTheme: IconThemeData(color: text),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 8,
        shadowColor: primary.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primary.withOpacity(0.3), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(20),
        hintStyle: const TextStyle(color: textDim),
        prefixIconColor: primary,
      ),
      iconTheme: const IconThemeData(color: primary),
    );
  }
}
