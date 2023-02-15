import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTypography {
  static final fontFamily = GoogleFonts.raleway().fontFamily;

  static TextTheme buildTextTheme() {
    return TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 48.0,
        letterSpacing: 3.0,
        fontFamily: fontFamily,
        height: 56.0,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 32.0,
        letterSpacing: 3.0,
        fontFamily: fontFamily,
        height: 40.0,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 30.0,
        letterSpacing: 3.0,
        fontFamily: fontFamily,
        height: 38.0,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 28.0,
        letterSpacing: 3.0,
        fontFamily: fontFamily,
        height: 36.0,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 24.0,
        letterSpacing: 2.0,
        fontFamily: fontFamily,
        height: 32.0,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 20.0,
        letterSpacing: 2.0,
        fontFamily: fontFamily,
        height: 28.0,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 14.0,
        letterSpacing: 1.0,
        fontFamily: fontFamily,
        height: 20.0,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 12.0,
        letterSpacing: 1.0,
        fontFamily: fontFamily,
        height: 16.0,
      ),
      displayLarge: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 28.0,
        letterSpacing: 1.0,
        fontFamily: fontFamily,
        height: 36.0,
      ),
      displayMedium: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 18.0,
        letterSpacing: 1.0,
        fontFamily: fontFamily,
        height: 24.0,
      ),
      displaySmall: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 14.0,
        letterSpacing: 1.0,
        fontFamily: fontFamily,
        height: 20.0,
      ),
      labelSmall: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 10.0,
        letterSpacing: 1.0,
        fontFamily: fontFamily,
        height: 12.0,
      ),
    );
  }
}
