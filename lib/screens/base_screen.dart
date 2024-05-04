import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
}

abstract class BaseScreenState<W extends BaseScreen> extends State<W> {
  late AppLocalizations S;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    S = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(alignment: Alignment.topCenter, children: [
        _buildReloadIcon(),
        Center(child: body(context)),
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

  Widget body(BuildContext context);
}
