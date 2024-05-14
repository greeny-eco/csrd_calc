import 'dart:math';

import 'package:csrd_calc/controllers/app_controller.dart';
import 'package:csrd_calc/data/firebase_provider.dart';
import 'package:csrd_calc/data/result.dart';
import 'package:csrd_calc/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'mock/mock_firebase_provider.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Setup language
  const locale = Locale('en', 'US');
  final S = await AppLocalizations.delegate.load(locale);

  // Setup fonts
  FontLoader('Roboto')
    ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
    ..load();

  testWidgets('Not in EU', (WidgetTester tester) async {
    // tester.view.physicalSize = const Size(500, 2000);
    // debugPrint("${tester.view.physicalSize}");
    await tester.setUp(locale);
    await tester.expectQuestionAndClickAnswer(
      question: S.isWithinEuQuestion,
      answer: S.no,
    );
    // debugDumpApp();
    // await tester.takeScreenshot(name: "result");
    expect(
      find.byKey(ValueKey(Result(type: ResultType.futureDue, sinceYear: 2029))),
      findsOneWidget,
    );
  });

  testWidgets('Not listed', (WidgetTester tester) async {
    await tester.setUp(locale);
    await tester.expectQuestionAndClickAnswer(
      question: S.isWithinEuQuestion,
      answer: S.yes,
    );
    await tester.expectQuestionAndClickAnswer(
      question: S.listedWithinEuQuestion,
      answer: S.no,
    );
    expect(
      find.byKey(ValueKey(Result(type: ResultType.notDue, sinceYear: 0))),
      findsOneWidget,
    );
  });
}

extension WidgetTesterQuestionAnswer on WidgetTester {
  setUp(Locale locale) async {
    // Build our app and trigger a frame
    final FirebaseProvider firebaseProvider = MockFirebaseProvider();
    await firebaseProvider.init();
    await pumpWidget(CsrdCalcApp(
      key: ValueKey(Random().nextDouble()),
      defaultLocale: locale,
      firebaseProvider: firebaseProvider,
    ));

    // Reset app state
    await AppStateController().gotoStart();

    // Should show loading
    expect(find.byType(LoadingIndicator), findsOneWidget);
    await pumpAndSettle(const Duration(milliseconds: 300));
  }

  pumpAndWaitForPageTransition() =>
      pumpAndSettle(const Duration(milliseconds: 300));

  expectQuestionAndClickAnswer({
    required String question,
    required String answer,
  }) async {
    expect(find.text(question), findsOneWidget);
    // Check question
    await pumpAndWaitForPageTransition();
    // Tap answer
    expect(find.text(answer), findsAtLeast(1));
    await tap(find.text(answer).last);
    await pumpAndWaitForPageTransition();
  }
}
