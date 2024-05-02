import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  scaffoldBackgroundColor: backgroundColor,
  textTheme: textTheme,
  useMaterial3: true,
);

const primaryColor = Color(0xFF287379);
const backgroundColor = Color(0xFFe8e7d5);
const textColor = Color(0xFF515b63);

MaterialStateProperty<Color> get primaryColorMaterial =>
    MaterialStateProperty.all<Color>(primaryColor);

const textTheme = TextTheme(
  titleLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    color: textColor,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    color: textColor,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    color: Colors.black38,
  ),
);
