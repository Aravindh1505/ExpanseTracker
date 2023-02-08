import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.raleway().fontFamily,
        appBarTheme: buildAppBarTheme(),
        floatingActionButtonTheme: buildFloatingActionButtonThemeData(),
        pageTransitionsTheme:
            const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()}),
        textTheme: buildTextTheme());
  }

  /*Custom Theme Builder Methods*/
  static AppBarTheme buildAppBarTheme() {
    return const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  static TextTheme buildTextTheme() {
    return const TextTheme(
      /*titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
      ),
      bodySmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w700,
      ),
      labelSmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),*/
    );
  }

  static FloatingActionButtonThemeData buildFloatingActionButtonThemeData() {
    return const FloatingActionButtonThemeData(
        extendedTextStyle: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
    ));
  }
}
