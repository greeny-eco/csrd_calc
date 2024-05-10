import 'package:csrd_calc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'mock/mock_firebase_provider.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Use Mockito to mock FirebaseAnalytics.instance
  final mockFirebaseProvider = MockFirebaseProvider();
  // when(FirebaseProvider()).thenReturn(mockFirebaseProvider);

  final S = await AppLocalizations.delegate.load(const Locale('it'));

  pumpAndWaitForPageTransition(WidgetTester tester) =>
      tester.pumpAndSettle(const Duration(milliseconds: 300));

  testWidgets('Not in EU', (WidgetTester tester) async {
    // tester.view.physicalSize = const Size(500, 2000);
    debugPrint("${tester.view.physicalSize}");

    // Build our app and trigger a frame
    await tester.pumpWidget(CsrdCalcApp(
      firebaseProvider: mockFirebaseProvider,
    ));

    // Should show loading
    expect(find.byType(LoadingIndicator), findsOneWidget);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    // First question is
    expect(find.text(S.isWithinEuQuestion), findsOneWidget);
    await pumpAndWaitForPageTransition(tester);

    // Tap "No"
    // debugDumpApp();
    await tester.tap(find.text(S.no));
    await pumpAndWaitForPageTransition(tester);
  });
}
