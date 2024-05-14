import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

class FirebaseWidget extends InheritedWidget {
  static FirebaseProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FirebaseWidget>()!.provider;

  final FirebaseProvider provider;

  const FirebaseWidget({
    super.key,
    required this.provider,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant FirebaseWidget oldWidget) {
    return oldWidget != this;
  }
}

class FirebaseProvider {
  FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get firebaseAnalyticsObserver =>
      FirebaseAnalyticsObserver(analytics: analytics);

  const FirebaseProvider();
}
