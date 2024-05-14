import 'package:csrd_calc/data/result.dart';
import 'package:csrd_calc/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'mock/mock_firebase_provider.dart';
import 'screenshots.dart';

void main() async {
  // Setup
  TestWidgetsFlutterBinding.ensureInitialized();
  final S = await AppLocalizations.delegate.load(const Locale('it'));
  FontLoader('Roboto')
    ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
    ..load();

  testWidgets('Not in EU', (WidgetTester tester) async {
    // tester.view.physicalSize = const Size(500, 2000);
    // debugPrint("${tester.view.physicalSize}");
    await tester.setUp();
    await tester.expectQuestionAndClickAnswer(
      question: S.isWithinEuQuestion,
      answer: S.no,
    );
    // debugDumpApp();
    await tester.takeScreenshot(name: "result");
    expect(
      find.byKey(ValueKey(Result(type: ResultType.futureDue, sinceYear: 2029))),
      findsOneWidget,
    );
  });

  testWidgets('Not listed', (WidgetTester tester) async {
    await tester.setUp();
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
  setUp() async {
    // Build our app and trigger a frame
    await pumpWidget(CsrdCalcApp(
      firebaseProvider: MockFirebaseProvider(),
    ));

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
