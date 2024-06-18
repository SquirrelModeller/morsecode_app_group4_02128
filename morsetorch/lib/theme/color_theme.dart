import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 196, 223, 230),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 196, 223, 230),
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 196, 223, 230),
  ),
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 196, 223, 230),
    ),
);

ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 18, 32, 47),
    foregroundColor: Colors.black,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 18, 32, 47)
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 18, 32, 47)
  ),
);