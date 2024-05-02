import 'package:flutter/foundation.dart';
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
        _buildReloadIcon(),
        Center(child: child),
      ]),
    ));
  }

  Widget _buildReloadIcon() => Positioned(
      top: 60,
      child: Opacity(
        opacity: 0.05,
        child: Image.asset(
          '${kReleaseMode ? 'assets/' : ''}images/logo-greeny.png',
        ),
      ));
}
