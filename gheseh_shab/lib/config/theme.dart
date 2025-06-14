import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyText1: TextStyle(fontFamily: 'dana', color: Colors.black),
      bodyText2: TextStyle(fontFamily: 'dana', color: Colors.black87),
      headline1: TextStyle(
          fontFamily: 'dana', fontWeight: FontWeight.bold, fontSize: 24),
      headline2: TextStyle(
          fontFamily: 'dana', fontWeight: FontWeight.bold, fontSize: 20),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueAccent,
      titleTextStyle: TextStyle(
        fontFamily: 'dana',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyText1: TextStyle(fontFamily: 'dana', color: Colors.white),
      bodyText2: TextStyle(fontFamily: 'dana', color: Colors.white70),
      headline1: TextStyle(
          fontFamily: 'dana', fontWeight: FontWeight.bold, fontSize: 24),
      headline2: TextStyle(
          fontFamily: 'dana', fontWeight: FontWeight.bold, fontSize: 20),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      titleTextStyle: TextStyle(
        fontFamily: 'dana',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}
