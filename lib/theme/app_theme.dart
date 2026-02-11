import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette: News/Media Red + Vibrant Block Style
  static const Color primary = Color(0xFFDC2626); // Vibrant Red
  static const Color primaryContainer = Color(0xFFEF4444); // Light Red
  static const Color background = Color(0xFFFEF2F2); // Warm Light Grey
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF111827); // Deep Grey
  static const Color textLight = Color(0xFF6B7280); // Cool Grey

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryContainer,
        surface: surface,
        background: background,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: text,
        onBackground: text,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: text,
          letterSpacing: -0.5,
        ),
        titleLarge: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: text,
        ),
        bodyLarge: const TextStyle(fontSize: 16, color: text),
        bodyMedium: const TextStyle(fontSize: 14, color: textLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Floating feel
        foregroundColor: text,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 24,
          fontWeight: FontWeight.w800, // Extra bold
          color: primary,
        ),
        iconTheme: IconThemeData(color: primary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 4, // Moderate elevation
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(20),
        hintStyle: const TextStyle(color: textLight),
        prefixIconColor: primary,
      ),
      iconTheme: const IconThemeData(color: primary),
    );
  }
}
