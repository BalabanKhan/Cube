import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Merhametsiz Kontrast (The UI Colors)
  static const Color oledBlack = Color(0xFF000000);
  static const Color clinicalWhite = Color(0xFFFFFFFF);
  static const Color murderRed = Color(0xFFD90429);

  // Sanatın Özgün Renkleri (The Organic Art Colors)
  static const Color mustardYellow = Color(0xFFE4B04A);
  static const Color dirtyBlue = Color(0xFF3B4D61);
  static const Color rustyOrange = Color(0xFFD35400);

  static ThemeData get brutalistTheme {
    return ThemeData(
      scaffoldBackgroundColor: oledBlack,
      brightness: Brightness.dark,
      
      // Brutalist UI: No rounded corners anywhere
      appBarTheme: const AppBarTheme(
        backgroundColor: oledBlack,
        elevation: 0,
        centerTitle: true,
      ),
      
      textTheme: TextTheme(
        // Ana Başlıklar ve Emirler
        displayLarge: GoogleFonts.spaceGrotesk(
          color: clinicalWhite, 
          fontSize: 32, 
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          color: clinicalWhite, 
          fontSize: 24, 
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        
        // Süreler ve Utanç Logları
        bodyLarge: GoogleFonts.ibmPlexMono(
          color: clinicalWhite, 
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.ibmPlexMono(
          color: clinicalWhite, 
          fontSize: 16,
        ),
      ),
      
      // Görünmez Butonlar (Floating giant text)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: clinicalWhite,
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 20, 
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            decoration: TextDecoration.underline,
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      
      // Keskin köşeli standart butonlar
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: clinicalWhite,
          foregroundColor: oledBlack,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), // 0.0 radius
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 18, 
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
