import 'package:csrd_calc/controllers/app_controller.dart';
import 'package:csrd_calc/screens/base_screen.dart';
import 'package:csrd_calc/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/result.dart';
import '../globals.dart';

class ResultScreen extends BaseScreen {
  final Result result;

  const ResultScreen(this.result, {super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends BaseScreenState<ResultScreen> {
  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.logEvent(
      name: "csrd_result",
      parameters: {
        'resultType': widget.result.type.name,
        'resultYear': widget.result.sinceYear,
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      key: ValueKey(widget.result),
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
        const Spacer(),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          label: Text(S.restart),
          icon: const Icon(Icons.restart_alt),
          onPressed: () => AppStateController().gotoStart(context),
        ),
        const SizedBox(height: 16),
        _buildPoweredByText(),
      ]),
    );
  }

  Widget _buildIcon() => Icon(
        switch (widget.result.type) {
          ResultType.pastDue => Icons.content_paste,
          ResultType.futureDue => Icons.content_paste_go,
          ResultType.notDue => Icons.content_paste_off,
          ResultType.invalidState => Icons.error,
        },
        color: switch (widget.result.type) {
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
            text: switch (widget.result.type) {
          ResultType.pastDue => S.pastDueResult,
          ResultType.futureDue => S.futureDueResult,
          ResultType.notDue => S.notDueResult,
          ResultType.invalidState => "",
        }),
        TextSpan(
          text: switch (widget.result.type) {
            ResultType.pastDue ||
            ResultType.futureDue =>
              "${widget.result.sinceYear}",
            ResultType.notDue || ResultType.invalidState => "",
          },
          style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        TextSpan(
            text: switch (widget.result.type) {
          ResultType.pastDue ||
          ResultType.futureDue =>
            S.fiscalYearResult("${widget.result.sinceYear - 1}"),
          ResultType.notDue => "",
          ResultType.invalidState => S.error
        }),
      ]));

  Widget _buildAdditionalText() => widget.result.text?.isNotEmpty == true
      ? Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            widget.result.text!,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ))
      : Container();

  Widget _buildDebugText() => widget.result.type == ResultType.invalidState
      ? Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            "Debug info: ${AppStateController().currentState}",
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
