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
      iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.black54, fontFamily: 'dana'),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF0E2A3A), // رنگ پس‌زمینه تیره
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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.white54, fontFamily: 'dana'),
    ),
  );
}
