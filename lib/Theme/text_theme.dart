import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

abstract class AppTypography {
  static TextTheme createTextTheme() {


    return TextTheme(
      displayLarge: GoogleFonts.syneMono( ),
      displayMedium: GoogleFonts.syneMono( ),
      displaySmall: GoogleFonts.syneMono( ),

      headlineLarge: GoogleFonts.syneMono(),
      headlineMedium: GoogleFonts.syneMono(),
      headlineSmall: GoogleFonts.syneMono(),

      titleLarge: GoogleFonts.syneMono(),
      titleMedium: GoogleFonts.syneMono(fontWeight: FontWeight.w400),
      titleSmall: GoogleFonts.syneMono(fontWeight: FontWeight.w400),

      labelLarge: GoogleFonts.anekGurmukhi(fontWeight: FontWeight.w400),
      labelMedium: GoogleFonts.anekGurmukhi(fontWeight: FontWeight.w400),
      labelSmall: GoogleFonts.anekGurmukhi(fontWeight: FontWeight.w400),

      bodyLarge: GoogleFonts.anekGurmukhi(),
      bodyMedium: GoogleFonts.anekGurmukhi(),
      bodySmall: GoogleFonts.anekGurmukhi(),
   
    );
  }
}
