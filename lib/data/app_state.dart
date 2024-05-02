class AppState {
  bool? isWithinUE;
  bool? isBankOrInsurance;
  Balance? balance;
  NetIncome? netIncome;
  EmployeeCount? employeeCount;
  bool? listedWithinUE;

  // Track progress
  int answeredQuestions;
  int totalQuestions;

  AppState({
    this.isWithinUE,
    this.isBankOrInsurance,
    this.balance,
    this.netIncome,
    this.employeeCount,
    this.listedWithinUE,
    this.answeredQuestions = 0,
    this.totalQuestions = 6,
  });

  AppState.clone(AppState state)
      : this(
          isWithinUE: state.isWithinUE,
          isBankOrInsurance: state.isBankOrInsurance,
          balance: state.balance,
          netIncome: state.netIncome,
          employeeCount: state.employeeCount,
          listedWithinUE: state.listedWithinUE,
          answeredQuestions: state.answeredQuestions,
          totalQuestions: state.totalQuestions,
        );

  @override
  String toString() {
    return 'AppState{isWithinUE: $isWithinUE, isBankOrInsurance: $isBankOrInsurance, balance: $balance, netIncome: $netIncome, employeeCount: $employeeCount, listedWithinUE: $listedWithinUE, answeredQuestions: $answeredQuestions, totalQuestions: $totalQuestions}';
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
