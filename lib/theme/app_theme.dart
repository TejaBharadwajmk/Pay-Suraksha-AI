import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // â”€â”€ Colors â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const Color blue        = Color(0xFF1A6BFF);
  static const Color blueDeep    = Color(0xFF0A4FD4);
  static const Color blueDark    = Color(0xFF061F80);
  static const Color blueLight   = Color(0xFFE8F1FF);
  static const Color blueMid     = Color(0xFFDAEAFF);
  static const Color green       = Color(0xFF18C97A);
  static const Color orange      = Color(0xFFFF8A2B);
  static const Color red         = Color(0xFFFF3B55);
  static const Color purple      = Color(0xFF7B5EFF);
  static const Color background  = Color(0xFFF3F7FF);
  static const Color cardBg      = Color(0xFFFFFFFF);
  static const Color dark        = Color(0xFF0B1A3F);
  static const Color mid         = Color(0xFF3D527A);
  static const Color muted       = Color(0xFF8496BE);
  static const Color border      = Color(0x1A1A6BFF);

  // â”€â”€ Gradients â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A80FF), Color(0xFF1A6BFF), Color(0xFF0A4FD4)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A4FD4), Color(0xFF1A6BFF), Color(0xFF2A8BFF)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF2040), Color(0xFFFF3B55), Color(0xFFFF5070)],
  );

  // â”€â”€ Shadows â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0D1E50).withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> blueShadow = [
    BoxShadow(
      color: blue.withValues(alpha: 0.42),
      blurRadius: 36,
      offset: const Offset(0, 10),
    ),
  ];

  // â”€â”€ Text Styles â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static TextStyle get displayLarge => GoogleFonts.sora(
    fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white,
    letterSpacing: -0.5,
  );

  static TextStyle get headingLarge => GoogleFonts.sora(
    fontSize: 24, fontWeight: FontWeight.w800, color: dark,
    letterSpacing: -0.3,
  );

  static TextStyle get headingMedium => GoogleFonts.sora(
    fontSize: 18, fontWeight: FontWeight.w700, color: dark,
  );

  static TextStyle get headingSmall => GoogleFonts.sora(
    fontSize: 15, fontWeight: FontWeight.w700, color: dark,
  );

  static TextStyle get labelLarge => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w600, color: dark,
  );

  static TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: 12, fontWeight: FontWeight.w500, color: muted,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w400, color: mid,
  );

  static TextStyle get caption => GoogleFonts.dmSans(
    fontSize: 11, fontWeight: FontWeight.w500, color: muted,
    letterSpacing: 0.5,
  );

  // â”€â”€ Theme Data â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: blue,
      surface: cardBg,
    ),
    scaffoldBackgroundColor: background,
    textTheme: GoogleFonts.dmSansTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: cardBg,
      foregroundColor: dark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.sora(
        fontSize: 17, fontWeight: FontWeight.w700, color: dark,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: border, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        minimumSize: const Size(double.infinity, 56),
        textStyle: GoogleFonts.sora(
          fontSize: 16, fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

