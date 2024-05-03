import 'package:csrd_calc/screens/result_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

import '../data/app_state.dart';
import '../data/question_answer.dart';
import '../data/result.dart';
import '../screens/question_screen.dart';

class AppStateController {
  static final AppStateController _instance = AppStateController._internal();

  factory AppStateController() {
    return _instance;
  }

  AppStateController._internal();

  AppState _state = AppState();

  AppState get currentState => AppState.clone(_state);

  Widget get nextScreen {
    // L'azienda è in EU? Se no mi fermo subito...
    if (_state.isWithinUE == null) {
      return QuestionScreen(
        Question("La tua azienda è registrata nell'Unione Europea?", answers: [
          Answer("Sì", value: true),
          Answer("No", value: false),
        ]),
        (Answer ans) => _state.isWithinUE = ans.value as bool,
      );
    }
    if (_state.isWithinUE == false) {
      return ResultScreen(Result(
        sinceYear: 2029,
        type: ResultType.futureDue,
        text: "Dal 2029 saranno coinvolte le imprese e figlie succursali con "
            "capogruppo extra-UE, per le quali la capogruppo abbia generato in "
            "UE ricavi netti superiori a 150 milioni di euro per ciascuno "
            "degli ultimi due esercizi consecutivi e almeno un'impresa figlia "
            "soddisfi i requisiti dimensionali della CSRD o una succursale "
            "abbia generato ricavi netti superiori a 40 milioni di euro "
            "nell'esercizio precedente.",
      ));
    }

    // Aziende quotate in borsa
    if (_state.listedWithinUE == null) {
      return QuestionScreen(
        Question(
            "La tua azienda è quotata in borsa o in altri listini europei?",
            answers: [
              Answer("Sì ", value: true),
              Answer("No", value: false),
            ]),
        (Answer ans) => _state.listedWithinUE = ans.value as bool,
      );
    }
    if (_state.listedWithinUE == false) {
      return ResultScreen(Result(
        sinceYear: 0,
        type: ResultType.notDue,
        text: "Considera però che potresti comunque doverlo compilare in "
            "quanto fornitore di altro soggetto obbligato, oppure perché fai "
            "parte di un'azienda virtuosa e attenta all'ambiente.",
      ));
    }

    // Banche, assicurazioni e altri soggetti NFRD
    if (_state.isBankOrInsurance == null) {
      return QuestionScreen(
        Question(
            "La tua azienda è una banca o un'assicurazione con più di 500 "
            "dipendenti o altra entità già soggetta a NFRD?",
            answers: [
              Answer("Sì", value: true),
              Answer("No", value: false),
            ]),
        (Answer ans) => _state.isBankOrInsurance = ans.value as bool,
      );
    }
    if (_state.isBankOrInsurance == true) {
      return ResultScreen(Result(
        sinceYear: 2024,
        type: ResultType.pastDue,
        text: "Dal 2025 la normativa coinvolge le imprese attualmente soggette "
            "alla direttiva NFRD: imprese quotate, banche e assicurazioni che "
            "durante l’esercizio finanziario hanno avuto in media un numero di "
            "dipendenti > 500 e che, alla data di chiusura del bilancio, "
            "abbiano superato almeno uno dei seguenti limiti dimensionali:\n"
            "• 20 milioni di euro di stato patrimoniale\n"
            "• 40 milioni di euro di ricavi netti.",
      ));
    }

    // Richiedo bilancio, fatturato e dipendenti
    if (_state.balance == null) {
      return QuestionScreen(
        Question("Qual è il totale di bilancio della tua azienda?", answers: [
          Answer("Meno di 300k€", value: Balance.lessThan300k),
          Answer("Tra 300k€ e 20M€", value: Balance.between300kAnd20M),
          Answer("Più di 20M€", value: Balance.moreThan20M),
        ]),
        (Answer ans) => _state.balance = ans.value as Balance,
      );
    }
    if (_state.netIncome == null) {
      return QuestionScreen(
        Question("Qual è il fatturato netto della tua azienda?", answers: [
          Answer("Meno di 700k€", value: NetIncome.lessThan700k),
          Answer("Tra 700k€ e 40M€", value: NetIncome.between700kAnd40M),
          Answer("Più di 40M€", value: NetIncome.moreThan40M),
        ]),
        (Answer ans) => _state.netIncome = ans.value as NetIncome,
      );
    }
    if (_state.employeeCount == null) {
      return QuestionScreen(
        Question(
            "Quanti dipendenti ha la tua azienda (valore medio nell'anno)?",
            answers: [
              Answer("Meno di 10", value: EmployeeCount.lessThan10),
              Answer("Tra 10 e 250", value: EmployeeCount.between10And250),
              Answer("Più di 250", value: EmployeeCount.moreThan250),
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
        text: "La tua società deve preparare e pubblicare la relazione per nel "
            "2026 in conformità con i nuovi requisiti.",
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
        text: "Considera però che potresti comunque doverlo compilare in "
            "quanto fornitore di altro soggetto obbligato, oppure perché fai "
            "parte di un'azienda virtuosa e attenta all'ambiente.",
      ));
    } else {
      return ResultScreen(Result(
        sinceYear: 2027,
        type: ResultType.pastDue,
        text: "Le PMI quotate, a causa delle loro dimensioni più ridotte, "
            "delle risorse più limitate e tenuto conto del difficile contesto "
            "economico dovuto alla COVID-19, hanno anche la possibilità di "
            "essere esentate dall'obbligo di rendicontazione per un periodo "
            "transitorio di due anni. A tal fine, devono spiegare brevemente "
            "nella relazione sulla gestione perché non sono ancora in grado di "
            "adempiere all'obbligo. Se tale PMI si concede l'esenzione "
            "provvisoria dalla rendicontazione, deve pubblicare il suo primo "
            "rapporto per l'anno di rendicontazione 2028 nel 2029.",
      ));
    }

    // return ResultScreen(Result.invalidState());
  }

  gotoNextScreen(BuildContext context, {Widget? currentScreen}) {
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
            child: nextScreen,
          )),
    );
  }

  gotoStart(BuildContext context) {
    _state = AppState();
    gotoNextScreen(context);
  }
}
