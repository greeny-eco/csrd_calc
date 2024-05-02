import 'package:csrd_calc/controllers/app_controller.dart';
import 'package:csrd_calc/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const CsrdCalcApp(),
  );
}

class CsrdCalcApp extends StatelessWidget {
  const CsrdCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: AppStateController().nextScreen,
    );
  }
}
