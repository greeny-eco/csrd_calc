import 'package:flutter/material.dart';

/// URL to online version
final onlineVersionUrl = Uri.parse('https://calc.greeny.eco/');

/// Supported locales
const supportedLocales = [
  Locale('it'),
  Locale('en'),
  Locale('ar'),
  Locale('cs'),
  Locale('da'),
  Locale('de'),
  Locale('el'),
  Locale('es'),
  Locale('fi'),
  Locale('fr'),
  Locale('hu'),
  Locale('ja'),
  Locale('ko'),
  Locale('nl'),
  Locale('pl'),
  Locale('pt'),
  Locale('ro'),
  Locale('ru'),
  Locale('sv'),
];

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}
