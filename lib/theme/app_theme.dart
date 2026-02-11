import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF7C3AED); // Neon Purple
  static const Color secondary = Color(0xFFA78BFA); // Soft Purple
  static const Color accent = Color(0xFFF43F5E); // Neon Rose
  static const Color background = Color(0xFF0F0F23); // Deep Space Blue
  static const Color surface = Color(
    0xFF1E1E3F,
  ); // Slightly lighter background for cards
  static const Color text = Color(0xFFE2E8F0); // Light Grey Text

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: text,
        onBackground: text,
        error: accent,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.russoOne(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: text,
          shadows: [
            const Shadow(color: primary, blurRadius: 10, offset: Offset(0, 0)),
          ],
        ),
        displayMedium: GoogleFonts.russoOne(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: text,
        ),
        bodyLarge: GoogleFonts.chakraPetch(fontSize: 16, color: text),
        bodyMedium: GoogleFonts.chakraPetch(
          fontSize: 14,
          color: text.withOpacity(0.8),
        ),
        titleMedium: GoogleFonts.chakraPetch(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.russoOne(
          fontSize: 24,
          color: text,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: text),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: primary, width: 1),
        ),
        shadowColor: primary.withOpacity(0.4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: secondary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: GoogleFonts.chakraPetch(color: text.withOpacity(0.7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: accent.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: GoogleFonts.chakraPetch(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ).copyWith(
              overlayColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white.withOpacity(0.1);
                }
                return null;
              }),
            ),
      ),
    );
  }
}
