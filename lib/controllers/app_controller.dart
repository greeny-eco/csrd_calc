import 'package:csrd_calc/globals.dart';
import 'package:csrd_calc/screens/result_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_transition/page_transition.dart';

import '../data/app_state.dart';
import '../data/question_answer.dart';
import '../data/result.dart';
import '../screens/question_screen.dart';

class AppStateController {
  static final AppStateController _instance = AppStateController._internal();

  factory AppStateController() => _instance;

  AppStateController._internal();

  AppState _state = AppState();

  AppState get currentState => AppState.clone(_state);

  late AppLocalizations S;

  Widget get _nextScreen {
    // Non-EU companies
    if (_state.isWithinEu == null) {
      return QuestionScreen(
        Question(S.isWithinEuQuestion, answers: [
          Answer(S.yes, value: true),
          Answer(S.no, value: false),
        ]),
        (Answer ans) => _state.isWithinEu = ans.value as bool,
      );
    }
    if (_state.isWithinEu == false) {
      return ResultScreen(Result(
        sinceYear: 2029,
        type: ResultType.futureDue,
        text: S.notInEuResult,
      ));
    }

    // Listed companies
    if (_state.listedWithinEu == null) {
      return QuestionScreen(
        Question(S.listedWithinEuQuestion, answers: [
          Answer(S.yes, value: true),
          Answer(S.no, value: false),
        ]),
        (Answer ans) => _state.listedWithinEu = ans.value as bool,
      );
    }
    if (_state.listedWithinEu == false) {
      return ResultScreen(Result(
        sinceYear: 0,
        type: ResultType.notDue,
        text: S.notDueAdditionalText,
      ));
    }

    // Banks, insurances and other NFRD-requried companies
    if (_state.isBankOrInsurance == null) {
      return QuestionScreen(
        Question(S.isBankOrInsuranceQuestion, answers: [
          Answer(S.yes, value: true),
          Answer(S.no, value: false),
        ]),
        (Answer ans) => _state.isBankOrInsurance = ans.value as bool,
      );
    }
    if (_state.isBankOrInsurance == true) {
      return ResultScreen(Result(
        sinceYear: 2024,
        type: ResultType.pastDue,
        text: S.isBankOrInsuranceResult,
      ));
    }

    // Ask for balance, income and employee count
    if (_state.balance == null) {
      return QuestionScreen(
        Question(S.balanceQuestion, answers: [
          Answer(S.balanceLessThan300k, value: Balance.lessThan300k),
          Answer(S.balanceBetween300kAnd20M, value: Balance.between300kAnd20M),
          Answer(S.balanceMoreThan20M, value: Balance.moreThan20M),
        ]),
        (Answer ans) => _state.balance = ans.value as Balance,
      );
    }
    if (_state.netIncome == null) {
      return QuestionScreen(
        Question(S.incomeQuestion, answers: [
          Answer(S.incomeLessThan700k, value: NetIncome.lessThan700k),
          Answer(S.incomeBetween700kAnd40M, value: NetIncome.between700kAnd40M),
          Answer(S.incomeMoreThan40M, value: NetIncome.moreThan40M),
        ]),
        (Answer ans) => _state.netIncome = ans.value as NetIncome,
      );
    }
    if (_state.employeeCount == null) {
      return QuestionScreen(
        Question(S.employeeCountQuestion, answers: [
          Answer(S.employeeCountLessThan10, value: EmployeeCount.lessThan10),
          Answer(S.employeeCountBetween10And250,
              value: EmployeeCount.between10And250),
          Answer(S.employeeCountMoreThan250, value: EmployeeCount.moreThan250),
        ]),
        (Answer ans) => _state.employeeCount = ans.value as EmployeeCount,
      );
    }
    int trueConditionsFor2026 = [
      _state.balance == Balance.moreThan20M,
      _state.netIncome == NetIncome.moreThan40M,
      _state.employeeCount == EmployeeCount.moreThan250,
    ].where((e) => e == true).length;
    if (trueConditionsFor2026 >= 2) {
      return ResultScreen(Result(
        sinceYear: 2026,
        type: ResultType.pastDue,
        text: S.year2026Result,
      ));
    }
    int trueConditionsForExempt = [
      _state.balance == Balance.lessThan300k,
      _state.netIncome == NetIncome.lessThan700k,
      _state.employeeCount == EmployeeCount.lessThan10,
    ].where((e) => e == true).length;
    if (trueConditionsForExempt >= 2) {
      return ResultScreen(Result(
        sinceYear: 0,
        type: ResultType.notDue,
        text: S.notDueAdditionalText,
      ));
    } else {
      return ResultScreen(Result(
        sinceYear: 2027,
        type: ResultType.pastDue,
        text: S.pastDueAdditionalText,
      ));
    }

    // return ResultScreen(Result.invalidState());
  }

  gotoNextScreen(BuildContext context, {Widget? currentScreen}) {
    S = AppLocalizations.of(context)!;

    _state.answeredQuestions++;

    // Delay to show the previous response
    Future.delayed(
      const Duration(milliseconds: 300),
      () => Navigator.pushReplacement(
          context,
          PageTransition(
            type: currentScreen != null
                ? PageTransitionType.rightToLeftJoined
                : PageTransitionType.rightToLeft,
            childCurrent: currentScreen,
            child: _nextScreen,
          )),
    );
  }

  gotoStart([BuildContext? context]) {
    _state = AppState();
    context?.let((context) => gotoNextScreen(context));
  }
}
