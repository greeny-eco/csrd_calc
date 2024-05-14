import 'package:csrd_calc/data/firebase_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseProvider extends Mock implements FirebaseProvider {
  @override
  FirebaseAnalytics get analytics => MockFirebaseAnalytics();

  @override
  FirebaseAnalyticsObserver get firebaseAnalyticsObserver =>
      MockFirebaseAnalyticsObserver(analytics: analytics);
}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) =>
      Future.value();
}

class MockFirebaseAnalyticsObserver extends Mock
    implements FirebaseAnalyticsObserver {
  MockFirebaseAnalyticsObserver({required FirebaseAnalytics analytics});
}
