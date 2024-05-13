class Result {
  final ResultType type;
  final int sinceYear;
  final String? text;

  Result({required this.type, required this.sinceYear, this.text});

  Result.invalidState() : this(type: ResultType.invalidState, sinceYear: 0);

  @override
  String toString() {
    return 'Result{type: $type, text: $text}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Result &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          sinceYear == other.sinceYear;

  @override
  int get hashCode => type.hashCode ^ sinceYear.hashCode;
}

enum ResultType {
  pastDue,
  futureDue,
  notDue,
  invalidState,
}
