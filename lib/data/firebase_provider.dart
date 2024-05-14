import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../firebase_options.dart';

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
  const FirebaseProvider();

  init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get firebaseAnalyticsObserver =>
      FirebaseAnalyticsObserver(analytics: analytics);
}
