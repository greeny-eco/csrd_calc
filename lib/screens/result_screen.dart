import 'package:csrd_calc/controllers/app_controller.dart';
import 'package:csrd_calc/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/result.dart';
import '../globals.dart';
import '../widgets/app_scaffold.dart';

class ResultScreen extends StatelessWidget {
  final Result result;

  const ResultScreen(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        child: Container(
      constraints: const BoxConstraints(maxWidth: 490),
      child: Column(children: [
        Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 8),
            Expanded(child: _buildResultText()),
          ],
        ),
        _buildAdditionalText(),
        _buildDebugText(),
        const SizedBox(height: 48),
        ElevatedButton.icon(
          label: const Text("Ricomincia"),
          icon: const Icon(Icons.restart_alt),
          onPressed: () => AppStateController().gotoStart(context),
        ),
        const Spacer(),
        _buildPoweredByText(),
      ]),
    ));
  }

  Widget _buildIcon() => Icon(
        switch (result.type) {
          ResultType.pastDue => Icons.content_paste,
          ResultType.futureDue => Icons.content_paste_go,
          ResultType.notDue => Icons.content_paste_off,
          ResultType.invalidState => Icons.error,
        },
        color: switch (result.type) {
          ResultType.pastDue => Colors.red,
          ResultType.futureDue => Colors.amberAccent,
          ResultType.notDue => Colors.green,
          ResultType.invalidState => Colors.grey,
        },
        size: 96,
      );

  Widget _buildResultText() => RichText(
      textAlign: TextAlign.center,
      text: TextSpan(style: textTheme.bodyLarge, children: [
        TextSpan(
            text: switch (result.type) {
          ResultType.pastDue ||
          ResultType.futureDue =>
            "La tua azienda ${result.type == ResultType.pastDue ? "è già" : "sarà"} soggetta "
                "all'obbligo di compilazione del bilancio di sostenibilità a partire dal ",
          ResultType.notDue =>
            "La tua azienda non è soggetta all'obbligo di compilazione del bilancio di sostenibilità.",
          ResultType.invalidState => "",
        }),
        TextSpan(
          text: switch (result.type) {
            ResultType.pastDue || ResultType.futureDue => "${result.sinceYear}",
            ResultType.notDue || ResultType.invalidState => "",
          },
          style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        TextSpan(
            text: switch (result.type) {
          ResultType.pastDue ||
          ResultType.futureDue =>
            " (anno fiscale ${result.sinceYear - 1}).",
          ResultType.notDue => "",
          ResultType.invalidState =>
            "Si è verificato un errore durante l'elaborazione dei dati."
        }),
      ]));

  Widget _buildAdditionalText() => result.text?.isNotEmpty == true
      ? Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            result.text!,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ))
      : Container();

  Widget _buildDebugText() => result.type == ResultType.invalidState
      ? Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            "Informazioni per il debug: ${AppStateController().currentState}",
            style: textTheme.bodySmall,
          ))
      : Container();

  Widget _buildPoweredByText() => RichText(
          text: TextSpan(children: [
        TextSpan(
          style: textTheme.bodySmall,
          text: "Powered by ",
        ),
        TextSpan(
          style: textTheme.bodySmall?.copyWith(
            color: primaryColor,
          ),
          text: "greeny.eco",
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchUrl(onlineVersionUrl),
        ),
      ]));
}
