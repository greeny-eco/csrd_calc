import 'package:csrd_calc/globals.dart';
import 'package:csrd_calc/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/firebase_provider.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const FirebaseProvider firebaseProvider = FirebaseProvider();
  await firebaseProvider.init();

  runApp(CsrdCalcApp(
    defaultLocale: supportedLocales.first,
    firebaseProvider: firebaseProvider,
  ));
}

class CsrdCalcApp extends StatefulWidget {
  final FirebaseProvider firebaseProvider;
  final Locale defaultLocale;

  const CsrdCalcApp({
    required this.firebaseProvider,
    required this.defaultLocale,
    super.key,
  });

  static CsrdCalcAppState of(BuildContext context) =>
      context.findAncestorStateOfType<CsrdCalcAppState>()!;

  @override
  State<CsrdCalcApp> createState() => CsrdCalcAppState();
}

class CsrdCalcAppState extends State<CsrdCalcApp> {
  Locale get locale => _locale;
  late Locale _locale;

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
    _locale = widget.defaultLocale;
    Uri.base.queryParameters['lang']?.let((lang) => WidgetsBinding.instance
        .addPostFrameCallback((_) => locale = Locale(lang)));
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseWidget(
      provider: widget.firebaseProvider,
      child: MaterialApp(
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
          widget.firebaseProvider.firebaseAnalyticsObserver,
        ],
      ),
    );
  }
}
