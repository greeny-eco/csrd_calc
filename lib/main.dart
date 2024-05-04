import 'package:csrd_calc/globals.dart';
import 'package:csrd_calc/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'screens/welcome_screen.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CsrdCalcApp());
}

class CsrdCalcApp extends StatefulWidget {
  const CsrdCalcApp({super.key});

  static CsrdCalcAppState of(BuildContext context) =>
      context.findAncestorStateOfType<CsrdCalcAppState>()!;

  @override
  State<CsrdCalcApp> createState() => CsrdCalcAppState();
}

class CsrdCalcAppState extends State<CsrdCalcApp> {
  Locale get locale => _locale;
  Locale _locale = supportedLocales.first;

  /// To change language: CsrdCalcApp.of(context).locale = Locale(...);
  set locale(Locale newLocale) {
    if (newLocale != _locale && supportedLocales.contains(newLocale)) {
      debugPrint("Locale: $newLocale");
      setState(() => _locale = newLocale);
    }
  }

  @override
  void initState() {
    super.initState();
    Uri.base.queryParameters['lang']?.let((lang) => WidgetsBinding.instance
        .addPostFrameCallback((_) => locale = Locale(lang)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      locale: _locale,
      home: const WelcomeScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }
}
