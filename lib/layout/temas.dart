import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primaryColor: const Color(0xFF5964FB),
  accentColor: const Color(0xFFA9B3FF),
  backgroundColor: const Color(0xFFFFFFFF),
  dividerColor: Colors.black26,
  indicatorColor: const Color(0xFF000000),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFF000000),
    ),
    headline2: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF8FF1F),
    ),
    button: TextStyle(
      fontSize: 16.0,
      color: Color(0xFFFFFFFF),
    ),
    bodyText1: TextStyle(
      fontSize: 16.0,
      color: Color(0xFF000000),
    ),
    bodyText2: TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
      color: Color(0xFF575757),
    ),
  ),
);

final darkTheme = ThemeData(
  primaryColor: const Color(0xFFF8FF1F),
  accentColor: const Color(0xFFF8FF1F),
  backgroundColor: const Color(0xFF212121),
  scaffoldBackgroundColor: const Color(0xFF131314),
  indicatorColor: const Color(0xFFFFFFFF),
  dividerColor: const Color(0xFFA1A1A1),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFFFFF),
    ),
    headline2: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.w700,
      color: Color(0xFFF8FF1F),
    ),
    button: TextStyle(
      fontSize: 16.0,
      color: Color(0xFF000000),
    ),
    bodyText1: TextStyle(
      fontSize: 16.0,
      color: Color(0xFFFFFFFF),
    ),
    bodyText2: TextStyle(
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
      color: Color(0xFFB7B7B7),
    ),
  ),
);
