import 'package:flutter/material.dart';

import '../theme/typography.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: CustomTypography.fontFamily,
      appBarTheme: buildAppBarTheme(),
      floatingActionButtonTheme: buildFloatingActionButtonThemeData(),
      pageTransitionsTheme:
          const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()}),
    );
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

  static FloatingActionButtonThemeData buildFloatingActionButtonThemeData() {
    return const FloatingActionButtonThemeData(
        extendedTextStyle: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
    ));
  }
}
