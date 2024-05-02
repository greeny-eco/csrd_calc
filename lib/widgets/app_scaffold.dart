import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(alignment: Alignment.topCenter, children: [
        Positioned(
          top: 60,
          child: Opacity(
            opacity: 0.05,
            child: Image.asset('images/logo-greeny.png'),
          ),
        ),
        Center(
          child: child,
        ),
      ]),
    ));
  }
}
