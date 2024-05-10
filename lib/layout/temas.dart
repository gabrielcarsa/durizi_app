import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primaryColor: const Color(0xFF5964FB),
  secondaryHeaderColor: const Color(0xFFEDEDED),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  dividerColor: Colors.black26,
  indicatorColor: const Color(0xFF000000),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFF000000),
    ),
    displayMedium: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFF5964FB),
    ),
    displaySmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFF000000),
    ),
    labelLarge: TextStyle(
      fontSize: 16.0,
      color: Color(0xFFFFFFFF),
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      color: Color(0xFF000000),
    ),
    bodyMedium: TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
      color: Color(0xFF575757),
    ),
  ),
);

final darkTheme = ThemeData(
  primaryColor: const Color(0xFF5964FB),
  secondaryHeaderColor: const Color(0xFF212121),
  scaffoldBackgroundColor: const Color(0xFF131314),
  indicatorColor: const Color(0xFFFFFFFF),
  dividerColor: const Color(0xFFA1A1A1),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFFFFF),
    ),
    displayMedium: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFF5964FB),
    ),
    displaySmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFFFFF),
    ),
    labelLarge: TextStyle(
      fontSize: 16.0,
      color: Color(0xFFFFFFFF),
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      color: Color(0xFFFFFFFF),
    ),
    bodyMedium: TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
      color: Color(0xFFB7B7B7),
    ),
  ),
);
