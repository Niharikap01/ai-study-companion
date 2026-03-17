import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary gradient colors
  static const Color deepPurple = Color(0xFF4A148C);
  static const Color electricBlue = Color(0xFF00E5FF);
  
  // Accents
  static const Color tealAccent = Color(0xFF1DE9B6);
  static const Color coralAccent = Color(0xFFFF8A65);
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color softViolet = Color(0xFFB388FF);
  static const Color mintGreen = Color(0xFF69F0AE);

  static const Color backgroundDark = Color(0xFF0D0E15);
  static const Color backgroundLight = Color(0xFF1A1C29);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: electricBlue,
        secondary: neonCyan,
        surface: backgroundLight,
        background: backgroundDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white70,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white60,
        ),
      ),
    );
  }
}
