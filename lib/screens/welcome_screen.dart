import 'package:csrd_calc/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controllers/app_controller.dart';
import '../data/firebase_provider.dart';
import '../theme.dart';

class WelcomeScreen extends BaseScreen {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends BaseScreenState<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseWidget.of(context).analytics.logEvent(name: "csrdcalc_start");
      AppStateController().gotoNextScreen(context);
    });
  }

  @override
  Widget body(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 150),
        child: const LoadingIndicator(
          key: Key('loading'),
          indicatorType: Indicator.audioEqualizer,
          colors: palette,
        ));
  }
}
