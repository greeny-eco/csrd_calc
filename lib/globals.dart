import 'package:flutter/material.dart';

/// URL to online version
final onlineVersionUrl = Uri.parse('https://calc.greeny.eco/');

/// Supported locales
const supportedLocales = [
  Locale('it'),
  Locale('en'),
];

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}
