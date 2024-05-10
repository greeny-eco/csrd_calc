import 'package:csrd_calc/controllers/app_controller.dart';
import 'package:csrd_calc/globals.dart';
import 'package:csrd_calc/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../data/question_answer.dart';
import '../theme.dart';

class QuestionScreen extends BaseScreen {
  final Question question;
  final ValueSetter<Answer> setter;

  const QuestionScreen(this.question, this.setter, {super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends BaseScreenState<QuestionScreen> {
  Answer? _answer;

  @override
  Widget body(BuildContext context) {
    return Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: Text(
            key: const Key('question'),
            widget.question.text,
            style: textTheme.titleLarge,
          ),
        ),
        IconButton(
          tooltip: S.restart,
          onPressed: () => AppStateController().gotoStart(context),
          icon: Icon(
            Icons.restart_alt,
            semanticLabel: AppLocalizations.of(context)!.restart,
          ),
        )
      ]),
      const Divider(),
      const SizedBox(height: 16),
      Expanded(
          child: ListView.builder(
        itemCount: widget.question.answers.length,
        itemBuilder: (context, index) =>
            _buildAnswer(widget.question.answers[index], widget.setter),
      )),
      _buildProgressIndicator(),
    ]);
  }

  Widget _buildAnswer(Answer answer, ValueSetter<Answer> setter) =>
      RadioListTile<Answer>(
        title: Text(answer.text),
        // subtitle: ...
        activeColor: primaryColor,
        groupValue: _answer,
        value: answer,
        onChanged: _answer == null
            ? (answer) {
                setState(() => _answer = answer);
                answer?.let((a) => widget.setter.call(answer));
                AppStateController()
                    .gotoNextScreen(context, currentScreen: widget);
              }
            : null,
      );

  Widget _buildProgressIndicator() {
    final state = AppStateController().currentState;
    return Hero(
        tag: 'app-indicator',
        child: LinearProgressIndicator(
          value:
              state.answeredQuestions / (state.totalQuestions + 1).toDouble(),
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
        ));
  }
}
