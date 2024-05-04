class AppState {
  bool? isWithinEu;
  bool? isBankOrInsurance;
  Balance? balance;
  NetIncome? netIncome;
  EmployeeCount? employeeCount;
  bool? listedWithinEu;

  // Track progress
  int answeredQuestions;
  int totalQuestions;

  AppState({
    this.isWithinEu,
    this.isBankOrInsurance,
    this.balance,
    this.netIncome,
    this.employeeCount,
    this.listedWithinEu,
    this.answeredQuestions = 0,
    this.totalQuestions = 6,
  });

  AppState.clone(AppState state)
      : this(
          isWithinEu: state.isWithinEu,
          isBankOrInsurance: state.isBankOrInsurance,
          balance: state.balance,
          netIncome: state.netIncome,
          employeeCount: state.employeeCount,
          listedWithinEu: state.listedWithinEu,
          answeredQuestions: state.answeredQuestions,
          totalQuestions: state.totalQuestions,
        );

  @override
  String toString() {
    return 'AppState{isWithinUE: $isWithinEu, isBankOrInsurance: $isBankOrInsurance, balance: $balance, netIncome: $netIncome, employeeCount: $employeeCount, listedWithinUE: $listedWithinEu, answeredQuestions: $answeredQuestions, totalQuestions: $totalQuestions}';
  }
}

enum Balance {
  lessThan300k,
  between300kAnd20M,
  moreThan20M,
}

enum NetIncome {
  lessThan700k,
  between700kAnd40M,
  moreThan40M,
}

enum EmployeeCount {
  lessThan10,
  between10And250,
  moreThan250,
}
