import 'package:csrd_calc/controllers/app_controller.dart';
import 'package:flutter/material.dart';

import '../data/question_answer.dart';
import '../theme.dart';
import '../widgets/app_scaffold.dart';

class QuestionScreen extends StatefulWidget {
  final Question question;
  final ValueSetter<Answer> setter;

  const QuestionScreen(this.question, this.setter, {super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Answer? _answer;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        child: Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: Text(widget.question.text, style: textTheme.titleLarge),
        ),
        IconButton(
          onPressed: () => AppStateController().gotoStart(context),
          icon: const Icon(Icons.restart_alt),
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
    ]));
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
                if (answer != null) widget.setter.call(answer);
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
          value: (state.answeredQuestions + 1).toDouble() /
              (state.totalQuestions + 1).toDouble(),
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
        ));
  }
}
