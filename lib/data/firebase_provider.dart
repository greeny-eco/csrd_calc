import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseProvider {
  FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get firebaseAnalyticsObserver =>
      FirebaseAnalyticsObserver(analytics: analytics);

  FirebaseProvider();
}
